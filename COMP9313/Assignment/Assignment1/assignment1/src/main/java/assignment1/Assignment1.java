package assignment1;

import java.io.IOException;
import java.util.StringTokenizer;
import java.util.ArrayList;
import java.util.List;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
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
	public static class TokenizerMapper extends Mapper<Object, Text, Text, IntWritable> {

		private final static IntWritable one = new IntWritable(1);
		private Text word = new Text();

		public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
			StringTokenizer itr = new StringTokenizer(value.toString());
			/*
			 * Firstly, put all stringTokenizer object elements into a new ArrayList for the
			 * 'sliding' part.
			 */
			List<String> tokens = new ArrayList<String>();
			int tokensCount = itr.countTokens();
			int index = 0;
			int ngram = Integer.valueOf(context.getConfiguration().get("ngram"));
			FileSplit fileSplit = (FileSplit)context.getInputSplit();
			String filename = fileSplit.getPath().getName();
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
				context.write(word, one);
				index++;
			}
		}
	}

	public static class IntSumReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

		private IntWritable result = new IntWritable();

		public void reduce(Text key, Iterable<IntWritable> values, Context context)
				throws IOException, InterruptedException {
			int sum = 0;
			for (IntWritable val : values) {
				sum += val.get();
			}
			// System.out.println("sum" + sum);
			result.set(sum);
			// System.out.println("key" + key.toString());
			// System.out.println("result" + result);
			context.write(key, result);
		}
	}

	public static void main(String[] args) throws Exception {
		Configuration conf = new Configuration();
		/*
		 * args[0]: The value N for the ngram. For example, if the user is 
		 * 			interested only in bigrams, then args[0]=2.
		 * args[1]: The minimum count for an ngram to be included in the 
		 * 			output file. For example, if the user is interested 
		 * 			only in ngrams that appear at least 10 times across 
		 * 			the whole set of documents, then args[1]=10.
		 */
		Integer ngram = Integer.valueOf(args[0]);
		Integer minCount = Integer.valueOf(args[1]);
		/* 
		 * set args[0] & args[1] as parameter for configuration, map and reduce 
		 * can get them 
		*/
		conf.setInt("ngram", ngram);
		conf.setInt("minCount", minCount);
		Job job = Job.getInstance(conf, "word count");
		/*
		 * args[2]: The directory containing the files in input. 
		 * 			For example, args[2]=”/tmp/input/”
		 * args[3]: The directory where the output file will be stored. 
		 * 			For example, args[3]=”/tmp/output/”
		 */
		String source = args[2];
		String dest = args[3];
		FileSystem fs = FileSystem.get(conf);
		Path in =new Path(source);
		Path out =new Path(dest);
		// delete output dir if it exists for convinient
        if (fs.exists(out)) {
            fs.delete(out, true);
		}
		job.setMapperClass(TokenizerMapper.class);
		job.setCombinerClass(IntSumReducer.class);
		job.setJarByClass(Assignment1.class);
		job.setReducerClass(IntSumReducer.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(IntWritable.class);
		FileInputFormat.addInputPath(job, in);
		FileOutputFormat.setOutputPath(job, out);
		System.exit(job.waitForCompletion(true) ? 0 : 1);
	}
}