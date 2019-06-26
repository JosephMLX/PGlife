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
			int len = 2;
			while (itr.hasMoreTokens()) {
				tokens.add(itr.nextToken());
			}
			// slide the ArrayList for getting n-gram phrase
			while (index <= tokensCount - len) {
				String sb = "";
				List<String> sa = new ArrayList<String>();
				for (int i = index; i < index + len; i++) {
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
		Job job = Job.getInstance(conf, "word count");
		String source = args[0];
		String dest = args[1];
		FileSystem fs = FileSystem.get(conf);
		Path in =new Path(source);
        Path out =new Path(dest);
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
		// FileInputFormat.addInputPath(job, new Path("/import/glass/3/z5147810/Desktop/PGlife/COMP9313/Assignment/Assignment1/input"));
		// FileOutputFormat.setOutputPath(job, new Path("output"));
		System.exit(job.waitForCompletion(true) ? 0 : 1);
	}
}