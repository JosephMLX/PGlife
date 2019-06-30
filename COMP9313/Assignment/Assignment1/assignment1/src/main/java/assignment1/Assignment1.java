package assignment1;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.util.StringTokenizer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

/**
 * 
 * This class solves the problem posed for Assignment1
 *
 */
public class Assignment1 {

	// TODO: Write the source code for your solution here.
	public static class TokenizerMapper extends Mapper<Object, Text, Text, TimeAndFileName> {

		private final static IntWritable one = new IntWritable(1);
		private Text word = new Text();
		private Text fileName = new Text();

		public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
			/*
			* Firstly, put all stringTokenizer object elements into a new ArrayList for the
			* 'sliding' part.
			*/
			StringTokenizer itr = new StringTokenizer(value.toString());
			List<String> tokens = new ArrayList<String>();
			int tokensCount = itr.countTokens();
			int index = 0;
			int ngram = Integer.valueOf(context.getConfiguration().get("ngram"));
			FileSplit fileSplit = (FileSplit) context.getInputSplit();
			String fileNameStr = fileSplit.getPath().getName();
			fileName.set(fileNameStr);
			// System.out.println(filename);
			while (itr.hasMoreTokens()) {
				tokens.add(itr.nextToken());
			}
			// slide the ArrayList for getting n-gram phrase
			while (index <= tokensCount - ngram) {
				String sb = "";
				List<String> sa = new ArrayList<String>();
				for (int i = index; i < index + ngram; i++) {
					sa.add(tokens.get(i));
				}
				sb = String.join(" ", sa);
				word.set(sb);
				context.write(word, new TimeAndFileName(one, fileName));
				index++;
			}
		}
	}
	// combine all k,v pairs first
	public static class IntSumCombiner extends Reducer<Text, TimeAndFileName, Text, TimeAndFileName> {

		private TimeAndFileName result = new TimeAndFileName();
		public void reduce(Text key, Iterable<TimeAndFileName> values, Context context)
				throws IOException, InterruptedException {
			int sum = 0;
			Set<String> fileSet = new HashSet<String>();
			for (TimeAndFileName pair : values) {
				sum += pair.getTime().get();
				StringTokenizer itr = new StringTokenizer(pair.getFileName().toString(), ",");
				while (itr.hasMoreTokens()) {
					fileSet.add(itr.nextToken());
				}
			}
			// TODO: sort the filenames
			String filenames = String.join(" ", fileSet);
			result.set(new IntWritable(sum), new Text(filenames));
			context.write(key, result);
		}
	}

	public static class IntSumReducer extends Reducer<Text, TimeAndFileName, Text, TimeAndFileName> {

		private TimeAndFileName result = new TimeAndFileName();
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		public void reduce(Text key, Iterable<TimeAndFileName> values, Context context)
				throws IOException, InterruptedException {
			int sum = 0;
			Set<String> fileSet = new HashSet<String>();
			// minimum show up times
			int minCount = Integer.valueOf(context.getConfiguration().get("minCount"));
			for (TimeAndFileName pair : values) {
				sum += pair.getTime().get();
				StringTokenizer itr = new StringTokenizer(pair.getFileName().toString(), ",");
				while (itr.hasMoreTokens()) {
					fileSet.add(itr.nextToken());
				}
			}
			map.put(key.toString(), sum);

			System.out.println("key: "+key+"\n" + "sum:"+sum);
			if (sum < minCount) {
				return;
			}
			String filenames = String.join(" ", fileSet);
			result.set(new IntWritable(sum), new Text(filenames));
			context.write(key, result);
		}
	}

	public static void main(String[] args) throws Exception {
		Configuration conf = new Configuration();
		/*
		 * args[0]: The value N for the ngram. For example, if the user is interested
		 * only in bigrams, then args[0]=2. args[1]: The minimum count for an ngram to
		 * be included in the output file. For example, if the user is interested only
		 * in ngrams that appear at least 10 times across the whole set of documents,
		 * then args[1]=10.
		 */
		Integer ngram = Integer.valueOf(args[0]);
		Integer minCount = Integer.valueOf(args[1]);
		/*
		 * set args[0] & args[1] as parameter for configuration, map and reduce can get
		 * them
		 */
		conf.setInt("ngram", ngram);
		conf.setInt("minCount", minCount);
		Job job = Job.getInstance(conf, "word count");
		/*
		 * args[2]: The directory containing the files in input. For example,
		 * args[2]=”/tmp/input/” args[3]: The directory where the output file will be
		 * stored. For example, args[3]=”/tmp/output/”
		 */
		String source = args[2];
		String dest = args[3];
		FileSystem fs = FileSystem.get(conf);
		Path in = new Path(source);
		Path out = new Path(dest);
		// if input arguments number is not four, raise an exception
		try {
			if (args.length != 4) {
				throw new Exception();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// delete output dir if it exists for convinient
		if (fs.exists(out)) {
			fs.delete(out, true);
		}
		job.setMapperClass(TokenizerMapper.class);
		job.setCombinerClass(IntSumCombiner.class);
		job.setJarByClass(Assignment1.class);
		job.setReducerClass(IntSumReducer.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(TimeAndFileName.class);
		FileInputFormat.addInputPath(job, in);
		FileOutputFormat.setOutputPath(job, out);
		System.exit(job.waitForCompletion(true) ? 0 : 1);
	}
}

/*
 * Define an output format for this assignment to write legal output as:
 * "hadoop is   2  file01.txt file03.txt"
*/
class TimeAndFileName implements Writable {
	// fields
	private IntWritable time;
	private Text fileName;

	// A constructor with no argsIntTextPairhadoop will throw an error
	public TimeAndFileName() {
		this.time = new IntWritable(0);
		this.fileName = new Text();
	}

	public TimeAndFileName(IntWritable time, Text fileName) {
		this.time = time;
		this.fileName = fileName;
	}
	// this method will be used when deserializing data
	@Override
	public void readFields(DataInput dataInput) throws IOException {
		time.readFields(dataInput);
		fileName.readFields(dataInput);
	}
	// this method will be used when serializing data
	@Override
	public void write(DataOutput dataOutput) throws IOException {
		time.write(dataOutput);
		fileName.write(dataOutput);
	}

	public IntWritable getTime() {
		return time;
	}

	public void setTime(IntWritable time) {
		this.time = time;
	}

	public Text getFileName() {
		return fileName;
	}

	public void setFileName(Text fileName) {
		this.fileName = fileName;
	}

	public void set(IntWritable time, Text fileName) {
		this.time = time;
		this.fileName = fileName;
	}

	@Override
	public String toString() {
		return time.get() + "  " + fileName.toString();
	}
}