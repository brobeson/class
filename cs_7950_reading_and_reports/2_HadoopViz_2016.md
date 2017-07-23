This is a review of "HadoopViz: A MapReduce framework for extensible visualization of big spatial data," [1]. This article was retrieved on 2016 June 29 from http://ieeexplore.ieee.org.dist.lib.usu.edu/xpl/articleDetails.jsp?arnumber=7498274. Source code is available from https://github.com/aseldawy/spatialhadoop2, in the master branch. Tagged releases are available at https://github.com/aseldawy/spatialhadoop2/releases, though it's unclear which version was used in the paper.

The author's primary goal appears to be to overcome weaknesses in prior efforts to visualize big spatial data. The authors identified three main weaknesses with previous solutions. First, the solutions lacked generality. They were all tailored to specific types of data. One solution might only work for satellite data, while another might only work for Twitter data. Second, the previous solutions had to method of recovering, or estimating, missing data. Finally, the performance of the previous solutions dropped significantly with extremely large data sets, or producing extremely large visualizations.

The authors ran six experiments with different data sets, producing different types of visualizations. The authors used data from OpenStreetMaps and from NASA. The OpenStreetMap data is available at http://spatialhadoop.cs.umn.edu/datasets.html#osm. From this link, several data sets are available; it appears the authors used the all\_nodes, all\_ways, and lakes data sets. The NASA data set does not appear to be available any longer. The authors provide the URL http://e4ft101.cr.usgs.gov/MOLA/MYD11A1.005/, but I get a "Server not found" error when I try to use that URL. However, there appears to be global temperature data at http://data.giss.nasa.gov/gistemp/.

The authors' only clear assumption is that any given datum can be analyzed independent of any other datum. If analysis of a datum requires information about, for example, neighboring data, then the partitioning will not work. Each partition must be processable on it's own. Data at the edges of a partition would not have access to neighbors which are on the edge of the adjacent partition.

The authors propose a framework for partitioning the data set, analyzing it in parallel on a Hadoop cluster, then merging the results. With this framework, the user must implement four or five functions: `smooth`, `create-canvas`, `plot`, `merge`, and `write`. The `smooth` function is optional. Its purpose is to fill in missing data. By implementing this function, the user controls how the missing data is reconstructed. If implemented, the `smooth` function is processed in parallel on the cluster. The `create-canvas` function simply initializes a "blank" image for the final results. What constitutes "blank" varies with the data to be analyzed. It could be an array of sum-and-count tuples, if the final image should display an average; or it could be an array filled with 0's if the final image should display a summation. The `plot` function does the work of analyzing the data and summarizing it to the image. Continuing the average example, this function would add to the sum component of a pixel, and increment the count component. The `plot` function is processed in parallel on the cluster. The `merge` function combines the results from all the distributed jobs into one result image. How the merge should be implemented depends on how the data are partitioned for parallel jobs. The final function, `write`, converts the output of the `merge` function into an appropriate visualization: PNG, SVG, etc. A general overview of the entire process is given by the following pseudo-code:

```
hadoopviz(input data_set, input mbr, input image_size)
{
    // HadoopViz will determine how to partition the data
    partitions = partition(data_set)

    for 0 <= i < partitions.count
    {
        smooth(partitions[i])

        // MBR and BR are not explained in the paper. From the context, I
        // suspect the are minimum bounding rectangle and bounding rectangle,
        // respectively. Thus, the image created for the partition is a fraction
        // of the minimum bounding rectangle surrounding the entire data-set.
        image[i] = create-canvas(image_size * br[i] / mbr)
        for each datum in partitions[i]
            plot(datum, image[i])
    }

    merged_image = create-canvas(image_size)
    for 0 <= i < partitions.count
        merge(image[i], merge_image)
    write(merge_image, output_file)
}
```

The HadoopViz framework determines how the data will be partitioned. The following activity diagram demonstrates how the framework does this:

The authors ran six experiments, testing HadoopViz with various types of input data and various types of output visualizations. They did not compare their results with techniques developed by other researchers. They implemented a baseline, serial processing algorithm on a single computer. As expected, HadoopViz ran faster, often by an order of magnitude. The authors presented several graphs depicting run time as functions of: data set polygon count, resolution of the output image, number of Hadoop nodes, number of data set partitions, and the partitioning algorithm. They presented similar graphs for a single level of output resolution, and for multiple levels. For multi-level processing, they also presented run time as a function of the number of levels. The authors did not provide measurements of the quality of the output image, only the run time performance of the data analysis.

The authors mention one limitation to the current framework. Data reconstruction, that is, the `smooth` step, cannot be run over multiple partitions. In other words, data in partition P cannot influence data recovery in partition Q. They plan to support this functionality in the future.

This paper certainly presents an interesting, general, solution to the problem of analyzing large sets of spatial data. From the standpoint of a user or software engineer, the solution seems pretty straightforward. One merely needs to implement a handful of functions and plug them in. One apparent drawback, though, is that the user must be familiar with how HadoopViz will partition the data. This is because the merge function must be written with the partitioning method in mind. For example, default partitioning requires blending pixels, while spatial partition does not. HadoopViz does not improve the computational complexity of analyzing big data. Every datum must be processed; thus the algorithm is still O(n). It merely spreads n over multiple computing nodes. The experimental results, compared to a baseline of a single computer, are interesting, but expected. Comparisons to other distributed processing frameworks would be beneficial.

One idea to overcome the merge drawback I noted above, would be to require a merge function for each partition algorithm: default single level, spatial, default multi-level, and coarse pyramid. This would increase the development burden on the user, but then the merge function would not need to be tailored to the size of the data set, size of the output image, and multi vs. single level of resolution. HadoopViz could invoke the appropriate merge function for the partition scheme that it chose.

It would be interesting to adapt this technique to data sets which are spatial and temporal. To extend the NASA global temperature case study in the paper, if NASA had different data sets for each year, HadoopViz could produce an image of temperature gradients instead of absolute temperature. Alternatively, HadoopViz could be used to generate a video, visualizing how the data change over time. It seems this would require a modification to HadoopViz to allow multiple data sets as input to generate one output, or a preprocessing step to combine multiple data sets into one data set.

1. A. Eldawy et al., "HadoopViz: A MapReduce framework for extensible visualization of big spatial data," *2016 IEEE 32nd International Conference on Data Engineering (ICDE)*, Helsinki, Finland, 2016, pp. 601-612. doi: 10.1109/ICDE.2016.7498274

---

1. <del>The source of the paper using the IEEE reference style (Authors, Paper Title,
   Journal/Conference Name, Volume Number, Page Number, and Year).</del>
1. <del>The URL of the paper and source code if applicable.</del>
1. <del>The problem to be solved.</del> Why is the investigated problem interesting?
1. <del>The assumptions made by the authors. Explain how the authors use these
   assumptions in their solution. **What is your prediction on the final results
   without these assumption?**</del>
1. <del>Provide the URL of the source of the data set if mentioned in the paper. If
   no URL is provided, please indicate a URL to your knowledge for downloading
   similar data sets.</del>
1. <del>The algorithmic overview (i.e. pseudo-code) of the approach proposed in the
   paper. Please do not copy all the formulas from the paper. Pick out several
   important formulas for the important steps and **summarize each formula
   listed in your report in your one sentences.**</del>
1. <del>The results compare to others. Qualitatively, what kind of plots or figures
   are used for comparison? Quantitatively, what kind of performance metric(s)
   and/or statistical tests are used for comparison?</del>
1. <del>Shortcomings of the approach and future improvement **mentioned in the
   paper.**</del>
1. <del>Your evaluation of the paper in terms of the **technical novelty,
   computational complexity,** and **experimental results.**</del>
1. <del>Your suggestions about the possible improvement to solve the problem. **Based
   on your suggestions, can any assumption be eliminated?**</del>
1. <del>Your thoughts about applying the proposed techniques to other applications.</del>

