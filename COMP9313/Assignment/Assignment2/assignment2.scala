import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf

// Use the named values (val) below whenever your need to
// read/write inputs and outputs in your program. 
val inputFilePath  = "/import/glass/3/z5147810/Desktop/PGlife/COMP9313/Assignment/Assignment2/sample_input.txt"
val outputDirPath = "output"
		
val inputFileText = sc.textFile(inputFilePath, 1)
val words = inputFileText.map(line => line.split(","))
val fileSingle = words.map(x => {
	(x(0), foo(x(3)))
})
val fileCluster = fileSingle.groupByKey
val fileOutput = fileCluster.map(x => x._1 + "," + getMin(x._2).toString() + "B" + "," +
																									 getMax(x._2).toString() + "B" + "," +
																									 getMean(x._2).toString() + "B" + "," +
 																									 getVariance(x._2).toString() + "B").coalesce(1).saveAsTextFile(outputDirPath)

def foo(rawSize: String): Long = {
	val dataSize = 1024
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
	}

	// KB --> size * 1024
	else if (rawSize.takeRight(2) == "KB") {
		val sizeStr = rawSize.dropRight(2)
		val sizeInt = sizeStr.toInt
		sizeFinal = sizeInt * dataSize
	}
	//	B --> size
	else {
		val sizeStr = rawSize.dropRight(1)
		val sizeInt = sizeStr.toInt
		sizeFinal = sizeInt
	}
	return sizeFinal
}

def getMin(arg: Iterable[Long]): Long = {
	var min: Long = Long.MaxValue
	for (a <- arg) {
		if (a < min) {
			min = a
		}
	}
	return min
}

def getMax(arg: Iterable[Long]): Long = {
	var max: Long = 0
	for (a <- arg) {
		if (a > max) {
			max = a
		}
	}
	return max
}

def getMean(arg: Iterable[Long]): Long = {
	var sum: Long = 0
	var size: Long = 0
	var mean: Long = 0
	for (a <- arg) {
		sum = sum + a
		size = size + 1
	}
	mean = sum / size
	return mean
}

def getVariance(arg: Iterable[Long]): Long = {
	var mean: Long = getMean(arg)
	var sumSquare: Long = 0
	var size: Long = 0
	var variance: Long = 0
	for (a <- arg) {
		sumSquare = sumSquare + (a - mean) * (a - mean)
		size = size + 1
	}
	variance = sumSquare / size
	return variance
}
