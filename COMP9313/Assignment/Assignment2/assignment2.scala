import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf

// Use the named values (val) below whenever your need to
// read/write inputs and outputs in your program. 
// Object Assignment2 {
	def foo(rawSize: String): Int = {
		var sizeFinal = 0
		// TB --> size * 1024 * 1024 * 1024 * 1024
		if (rawSize.takeRight(2) == "TB") {
			val sizeStr = rawSize.dropRight(2)
			val sizeInt = sizeStr.toInt
			sizeFinal = sizeInt * dataSize * dataSize * dataSize * dataSize
		}
		// GB --> size * 1024 * 1024 * 1024
		else if (rawSize.takeRight(2) == "GB") {
			val sizeStr = rawSize.dropRight(2)
			val sizeInt = sizeStr.toInt
			sizeFinal = sizeInt * dataSize * dataSize * dataSize
		}

		// MB --> size * 1024 * 1024
		else if (rawSize.takeRight(2) == "MB") {
			val sizeStr = rawSize.dropRight(2)
			val sizeInt = sizeStr.toInt
			sizeFinal = sizeInt * dataSize * dataSize
			println(sizeFinal)
		}

		// KB --> size * 1024
		else if (rawSize.takeRight(2) == "KB") {
			val sizeStr = rawSize.dropRight(2)
			val sizeInt = sizeStr.toInt
			sizeFinal = sizeInt * dataSize
			println(sizeFinal)
		}
		//	B --> size
		else {
			val sizeStr = rawSize.dropRight(1)
			val sizeInt = sizeStr.toInt
			sizeFinal = sizeInt
			println(sizeFinal)
		}
		return sizeFinal
	}

	def main() {
		val inputFilePath  = "/import/glass/3/z5147810/Desktop/PGlife/COMP9313/Assignment/Assignment2/sample_input.txt"
		val outputDirPath = "output"
		val dataSize = 1024
		// Write your solution here
		val inputFileText = sc.textFile(inputFilePath, 1)
		val map = scala.collection.mutable.HashMap.empty[String, List[Int]]
		for (line <- inputFileText) {
            val splitted = line.split(",")
		    // domain url
		    val domain = splitted(0)
		    val endpoint = splitted(1)
		    val method = splitted(2)
		    // raw data size e.g: 32MB, 4KB...
		    val rawSize = splitted(3)
			val sizeFinal = foo(rawSize)
			if (map.contains(domain)) {
				println("YES")
				println(map)
				var dataList = map.get(domain).get
				println(dataList)
				dataList = dataList :+ sizeFinal
				println(dataList)
				map.put(domain, dataList) 
		    } else {
			    println("NO")
			    var dataList = List(sizeFinal)
			    map.put(domain, dataList)
		    }
		}
		println(map)
		println(map.contains("http://subdom0001.example.com"))
		// val words = inputFileText.flatMap(line => line.split(","))
    }
// }


// // words.length()
// val pairs = words.map(word => (word, 1))
// val counts = pairs.reduceByKey(_ + _)
// counts.saveAsTextFile(outputDirPath)
