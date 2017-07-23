This is a review of "Real-Time Animated Visualization of Massive Air-Traffic Trajectories" by Buschmann et al. [1] The article presents a method for real-time and interactive 3D visualization of air-traffic trajectory data. The filtering, 3D geometry generation, and final rendering are all implemented with GPU techniques. The authors do not describe the system; the GPU specs could be especially important. The GPU programming language is not specified. The authors, though, describe using vertex, geometry, and fragment shaders; thus I suspect they used OpenGL Shading Language (GLSL) or DirectX (HLSL). The data set was real air-traffic data around an airport for one month. The set was provided by Deutsche Flugsicherung GmbH. No evaluation or verification methods are described. The example images included in the article seem usable. There is no comparison to other techniques, though.

1. S. Buschmann, M. Trapp and J. Döllner, "Real-Time Animated Visualization of Massive Air-Traffic Trajectories," *Cyberworlds (CW), 2014 International Conference on*, Santander, 2014, pp. 174-181. doi: 10.1109/CW.2014.32

---

- [x] The problem to be solved.
- [x] The name of the key machine learning and visualization techniques employed/enhanced.
- [x] The data set(s).
- [x] The evaluation measures.
- [x] Experimental results (e.g., the compared techniques and the benchmark datasets).
- [x] Languages used for development.
- [x] etc.
