import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import scalaj.http._
import java.io._
import scala.xml.XML
import scala.collection.mutable.ListBuffer
import scala.collection.mutable.Set
import play.api.libs.json._


object CaseIndex {
    val LONGTIMEOUT = 60000         // long timeout set for stablility
    val SHORTTIMEOUT = 15000        // short timeout set for effiency
    def main(args: Array[String]) {
        // input argument: input file directory path
        val fileDirPath = args(0)
        // get all file names into one list by calling getFileList function
        val fileList = getFileList(fileDirPath)
        // initial index
        val index_response = Http("http://localhost:9200/legal_idx").method("PUT").header("Content-Type", "application/json").option(HttpOptions.connTimeout(SHORTTIMEOUT)).option(HttpOptions.readTimeout(SHORTTIMEOUT)).asString
        // create a mapping for elasticsearch to set index
        val mapping_response = Http("http://localhost:9200/legal_idx/cases/_mapping?pretty").postData("""{"cases":{"properties":{"id":{"type":"text"},"name":{"type":"text"},"url":{"type":"text"},"catchphrase":{"type":"text"},"sentence":{"type":"text"},"person":{"type":"text"},"location":{"type":"text"},"organization":{"type":"text"}}}}""").method("PUT").header("Content-Type", "application/json").option(HttpOptions.connTimeout(SHORTTIMEOUT)).option(HttpOptions.readTimeout(SHORTTIMEOUT)).asString
        fileList.foreach(file => {
            // parse file into xml
            val xml = XML.loadFile(file)

            // set for storing entities
            val person: Set[String] = Set()
            val location: Set[String] = Set()
            val organization: Set[String] = Set()
            
            // get full filename and prefix name
            val fileFullname = file.getName()
            val filePrefix = fileFullname.split("\\.")(0)

            // get name tag text from XML
            val name = getName(file)

            // get AustLII tag text as url from XML
            val url = getURL(file)

            // get catchphrase as a combined string from XML
            val catchphrase = getCatchphrase(file)

            // get all sentenses in a XML file into one ListBuffer
            val sentences = (xml \ "sentences" \ "sentence")
            val sentence_list = new ListBuffer[String]()
            sentences.foreach(sentence => {
                sentence_list += sentence.text.replace("\"","\\\"")

            })
            sentence_list.foreach(e_sentence => {
                var NLPResult = Http("""http://localhost:9000/?properties=%7B'annotators':'ner','outputFormat':'json'%7D""").
                                postData(e_sentence).method("POST").header("Content-Type", "application/json").
                                option(HttpOptions.connTimeout(LONGTIMEOUT)).option(HttpOptions.readTimeout(LONGTIMEOUT)).asString.body
            
                // parse reponse to JSON object
                val NLPJSON: JsValue = Json.parse(NLPResult)
                
                // get all entities
                val tokens = NLPJSON \\ "tokens"
                
                // travesal each token and add classify entities
                tokens.foreach(token=>{
                    val text = token \\ "word"
                    val ner = token \\ "ner"
                    var i = 0
                    val len = text.length
                    for(i <- 0 until len){
                        if(ner(i).toString == "\"PERSON\""){
                            person += text(i).toString
                        } else if(ner(i).toString == "\"LOCATION\""){
                            location += text(i).toString
                        } else if(ner(i).toString == "\"ORGANIZATION\""){
                            organization += text(i).toString
                        }
                    }   
                })
            })
            // stringfy lists
            val person_list = "[" + person.toList.mkString(",") + "]"
            val location_list = "[" + location.toList.mkString(",") + "]"
            val organization_list = "[" + organization.toList.mkString(",") + "]"
            val new_sentence_list = "[" + sentence_list.map(x=>"\"" + x.filter(_ >= ' ') + "\"").mkString(",") + "]"

            val post_Data = s"""{"id":"${filePrefix}","name":"${name}","url":"${url}","catchphrase":"${catchphrase}","sentence":${new_sentence_list},"person":${person_list},"location":${location_list},"organization":${organization_list}}"""
            
            // Post data to elasticsearch database
            val new_document_result = Http("http://localhost:9200/legal_idx/cases/"+filePrefix+"?pretty").
                                        postData(post_Data).method("PUT").header("Content-Type", "application/json").
                                        option(HttpOptions.readTimeout(SHORTTIMEOUT)).asString
            // print something after importing a file                                        
            print(filePrefix + " written" + "\n")
        })
    }


    // function get list of files in a directory path
    def getFileList(dir: String):List[File] = {
        val d = new File(dir)
        if (d.exists && d.isDirectory) {
            d.listFiles.filter(_.isFile).toList
        } else {
            List[File]()
        }
    }
    // function used to get <name> tag text
    def getName(file: File): String = {
        val xml = XML.loadFile(file)
        val name = (xml \ "name").text
        name
    }
    // function used to get <AustLII> tag text
    def getURL(file: File): String = {
        val xml = XML.loadFile(file)
        val sourceURL = (xml \ "AustLII").text
        sourceURL
    }
    // function used to get <catchphrase> tag text into one string
    def getCatchphrase(file: File): String = {
        val xml = XML.loadFile(file)
        var catchphrases = (xml \ "catchphrases" \ "catchphrase")
        var catchphraseSB = new StringBuilder("")

        catchphrases.foreach(catchphrase => {
            val _catchphrase = catchphrase.text + " "
            catchphraseSB ++= _catchphrase
        })

        var catchphraseStr = catchphraseSB.toString
        catchphraseStr = catchphraseStr.replaceAll("\n", " ")
        catchphraseStr
    }
}