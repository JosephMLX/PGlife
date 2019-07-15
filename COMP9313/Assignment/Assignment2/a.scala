import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf

	val inputFilePath  = "/import/glass/3/z5147810/Desktop/PGlife/COMP9313/Assignment/Assignment2/sample_input.txt"
	val outputDirPath = "output"
    // val conf = new SparkConf().setAppName("PayloadStatistics").setMaster("local")
    // val sc = new SparkContext(conf)
  def getMean(para: Iterable[Long]): Long = {
    var sum : Long = 0;
    var amount : Long = 0;
    var average : Long = 0;
    for (a <- para) {
      sum = a + sum
    }
    amount = para.size;
    average = sum/amount;
    return average;
  }

  def getVar(para: Iterable[Long]): Long = {
    var meanValue : Long = getMean(para);
    var squareSum : Long = 0;
    var length : Long = 0;
    var result : Long = 0;
    for (a <- para) {
      squareSum = squareSum + (a - meanValue) * (a - meanValue);
    }
    length = para.size;
    result = squareSum / length;
    return result;
  }


  def getMin(para: Iterable[Long]): Long = {
    var minValue : Long = Long.MaxValue;
    for (a <- para) {
      if(a < minValue){
        minValue = a;
      }
    }
    return minValue
  }


  def getMax(para: Iterable[Long]): Long = {
    var maxValue = -Long.MaxValue;
    for (a <- para) {
      if(a > maxValue){
        maxValue = a;
      }
    }
    return maxValue
  }


    val input = sc.textFile(inputFilePath).map(x => x.split(","))
    val keyValue = input.map(x => {
      val l = x(3).length()
      if (x(3)(l - 2) == 'M') (x(0), (x(3).slice(0, l - 2).toLong * 1048576).toLong)
      else if (x(3)(l - 2) == 'K') (x(0), (x(3).slice(0, l - 2).toLong * 1024).toLong)
      else (x(0), x(3).slice(0, l - 1).toLong)
    })
    keyValue.foreach(println)
    val keyValueList = keyValue.groupByKey
    keyValueList.foreach(println)
    val keyValueStatistics = keyValueList.map(x => x._1 + "," +
                                                  getMin(x._2).toString() + "B" + "," +
                                                  getMax(x._2).toString() + "B" + "," +
                                                  getMean(x._2).toString() + "B" + "," +
                                                  getVar(x._2).toString() + "B").
                                                  coalesce(1).saveAsTextFile(outputDirPath)
   

