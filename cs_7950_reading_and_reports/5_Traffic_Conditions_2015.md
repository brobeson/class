This is a summary of "Analysis and Visualization of Traffic Conditions of Road Network by Route Bus Probe Data," by Liu et al. [1]. The paper is available at http://ieeexplore.ieee.org.dist.lib.usu.edu/xpl/articleDetails.jsp?arnumber=7153888. The source code for the authors' implementation does not appear to readily available.

The authors are attempting to determine and visualize road congestion in urban areas. This information is vital to optimize rapid transit systems and improve roads in crowded cities.

The authors seem to assume that only congestion accounts for long travel times. A road can have no congestion, but travel times are long due to speed limits and traffic control devices such as stop lights. The raw data is converted to statistical data for particular road segments. If, however, a particular set of segments routinely see little traffic, but low speeds, erroneous analysis will tend to be false positives.

The authors do not provide a URL for their data source. I'm not aware of any similar data sets.

The authors start with raw GPS data for buses. They mine for data matching a given query (time, location, etc). That data is then converted to road segment data. Road segment data tells how much time a bus spends on a segment, typically defined as road between two intersections. They find two GPS data around the start node of a road segment, and estimate the time of passing through that start node. The time is assumed to be the same proportion as the distance. That is, if the start node is 1/3 of the distance between the two GPS data, then the bus will pass it in 1/3 of the time between the two GPS data. Finally, the road segment data is converted to statistical data for that road segment. The average time in the road segment, standard deviation, and other statistical values, are calculated over the entire time period of interest. From here, the authors' approach displays the "degree of congestion", though they do not explain how that value is calculated.

The visualization method is not really novel. Congestion is conveyed via color, with red road segments being most congested and blue segments being least congested. The authors are also able to display the probability of reaching certain road segments from an origin segment, based on the degrees of congestion.

The authors do not compare their results to others. They provide no performance metrics for their implementation. They describe an evaluation of their algorithm, but there is really no verification that it is correct. They present a sample output of a map with congestion visualization, but the reader has no way to verify that those roads really are so congested.

The glaring short coming seems to be the assumption of constant velocity through road segment nodes. They calculate the time through a node as the same proportion in time as the proportion in distance. If most buses are stopped at traffic lights for a time, prior to passing through, then the time is no longer the same proportion as the distance.

The visualizations presented in this paper are not really novel. The conversion from GPS data to road segment data is an interesting approach, but suffers from the flaw noted above.

Variable velocity needs to be handled. One possibility is to look at all the GPS data withing a range of the segment node. Another thought is to use the GPS velocity data.

Application of this algorithm seems pretty limited. It requires time and positional data for the objects in motion, and spatial node & segment data. One question that occurred to me while reading this paper, though, is how does road congestion correlate with light rail systems? Are roads along the paths of subways and elevated trains less congested?

1. D. Liu et al, "Analysis and Visualization of Traffic Conditions of Road Network by Route Bus Probe Data," *Multimedia Big Data (BigMM), 2015 IEEE International Conference on*, Beijing, 2015, pp. 248-251. doi: 10.1109/BigMM.2015.75

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
