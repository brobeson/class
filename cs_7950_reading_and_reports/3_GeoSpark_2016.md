This is a review of "A demonstration of GeoSpark: A cluster computing framework for processing big spatial data" [1]. This article was retrieved on 2016 June 29 from http://ieeexplore.ieee.org.dist.lib.usu.edu/xpl/articleDetails.jsp?arnumber=7498357. Source code is available from https://github.com/DataSystemsLab/GeoSpark, in the master branch. A tagged release is available at https://github.com/DataSystemsLab/GeoSpark/releases, though it's unclear which version was used in the paper.

This system attempts to implement a system which can analyze geospatial data. The authors claim that existing systems either are not scalable to larger data sets, or excel at batch processing at the expense of interactive analysis & visualization. Interactive analysis of large geospatial data sets would benefit users. They would be able to adjust their analysis on the fly. Without that capability, they must wait for the processing to complete, make a adjustments, then wait for the new processing to complete, repeating this cycle until they're satisfied with the results.

The authors assume the data to be analyzed is spatial in nature. GeoSpark is written specifically to take advantage of this type of data. This is the only clear assumption. I suspect the implementation will not work with non-spatial data; the partitioning process relies on this.

The authors do not provide access to data used in their research. In fact, they do little to describe the data used in their "demonstration scenarios". They describe two hypothetical data sets: trees in the San Francisco area, and populations of tigers and rabbits. It is not clear if these data were used in their demonstrations; though I suspect the authors are merely describing example data sets that could be used.

This paper does not present much in the way of an algorithm. They do present an architectural description, though. GeoSpark is built on top of Apache Spark, a distributed computing system. GeoSpark adds two layers on top of Apache Spark: a spatial resilient distributed dataset (SRDD) layer, then a spatial query processing layer. Apache Spark provides the abstraction resilient distributed dataset (RDD). GeoSpark's SRDD layer extends this abstraction to include spatial concepts such as points, rectangles, and polygons. This layer also provides a utility library for manipulating such objects. The spatial query processing layer provides utilities for processing spatial queries. The data is partitioned in the SRDD layer. The space is divided into a number of rectangular grid cells of unequal area. The grids are load balanced via pre-sampling, though the pre-sampling algorithm is not described. Each SRDD element is then assigned to the grid cell which contains it. If an element overlaps multiple grid cells, it is duplicated for each cell. This layer also able to initialize a spatial indexing structure such as a quad-tree. GeoSpark will adapt the index based on indexing overhead vs. the number of spatial objects to be indexed.

The spatial query processing layer provides three spatial queries: range, join, and KNN. These seem to be the main entry points to GeoSpark. A user processes their data by running a permutation of these queries. The range query will partition the data, create an index, run the query's predicate on each partition, then remove duplicates (created by partitioning) from the result set. The join query will partition the two data sets to be joined, create an index, then combines the two data sets based on the grid IDs of the data elements. If two elements spatially overlap, they are added to the result set. The KNN query will measure the distance from each element to an input point P. Elements are added and removed from a heap data structure. The heaps from each partition are merged, only keeping the *k* elements nearest to P.

The authors do not provide any performance metrics or comparisons. No information is provided about execution time nor result accuracy. There is no comparison to any other systems.

The authors do not list any shortcomings to their framework, nor any future enhancements.

In my opinion, HadoopViz [2] presents a better framework. GeoSpark extends an existing distributed processing system, Apache Spark, in an interesting manner. However, extending a framework is not very novel; it is done frequently in software engineering and developing new applications. This paper does not provide any experimental results, which makes it impossible to evaluate GeoSpark's performance with respect to other systems.

I can think of no improvements to this framework. That's not to say the framework is perfect; rather the description is too general. This also makes it difficult to gauge whether this framework can be adapted to other applications. Adapting it to non-spatial applications would require altering the partitioning algorithm so that it is not reliant on spatial characteristics.

1. J. Yu, J. Wu and M. Sarwat, "A demonstration of GeoSpark: A cluster computing framework for processing big spatial data," *2016 IEEE 32nd International Conference on Data Engineering (ICDE)*, Helsinki, Finland, 2016, pp. 1410-1413. doi: 10.1109/ICDE.2016.7498357
1. A. Eldawy et al., "HadoopViz: A MapReduce framework for extensible visualization of big spatial data," *2016 IEEE 32nd International Conference on Data Engineering (ICDE)*, Helsinki, Finland, 2016, pp. 601-612. doi: 10.1109/ICDE.2016.7498274

---

- [x] The source of the paper using the IEEE reference style (Authors, Paper Title, Journal/Conference Name, Volume Number, Page Number, and Year).
- [x] The URL of the paper and source code if applicable.
- [x] The problem to be solved. Why is the investigated problem interesting?
- [x] The assumptions made by the authors. Explain how the authors use these assumptions in their solution. **What is your prediction on the final results without these assumption?**
- [x] Provide the URL of the source of the data set if mentioned in the paper. If no URL is provided, please indicate a URL to your knowledge for downloading similar data sets.
- [x] The algorithmic overview (i.e. pseudo-code) of the approach proposed in the paper. Please do not copy all the formulas from the paper. Pick out several important formulas for the important steps and **summarize each formula listed in your report in your one sentences.**
- [x] The results compare to others. Qualitatively, what kind of plots or figures are used for comparison? Quantitatively, what kind of performance metric(s) and/or statistical tests are used for comparison?
- [x] Shortcomings of the approach and future improvement **mentioned in the paper.**
- [x] Your evaluation of the paper in terms of the **technical novelty, computational complexity,** and **experimental results.**
- [x] Your suggestions about the possible improvement to solve the problem. **Based on your suggestions, can any assumption be eliminated?**
- [x] Your thoughts about applying the proposed techniques to other applications.

