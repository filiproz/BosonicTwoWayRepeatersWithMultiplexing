# BosonicTwoWayRepeatersWithMultiplexing

This is the code used to generate the data and plots for the article ....

## Content
The code includes *Matlab* simulation of the performance of the two-way repeater architecture with multiplexing based on the concatenation of the GKP code with the [[7,1,3]] code.

The *Matlab* code is divided into four folders:

1. `SimulationPerformance` containing the code that generates the performance data, i.e. simulates the repeater error channels and error corrections.
2. `SimulationResources' containing the code that simulates the generation of the cube resource states.
3.  `DataAnalysis` containing tools to analyse the generated data in terms of maximising secret-key/entanglement rate per mode and comparing the performance of our strategy with certain other strategies.
4. `Data' providing most of the data used to obtain the results of the paper.

### Simulation Performance

The main piece of code is the function `InnerAndOuterLeafs.m`. It runs a simulation in which it tracks the errors in the two quadratures over the inner and outer leafs of a single elementary link and then extracts the logical error probabilities. Here by elementary link we refer to a link between consecutive major repeater nodes that are capable of generating the resource states. The input to these functions include the major node repeater separation, the amount of GKP squeezing, the homodyne detection efficiency, the number of channels followed by GKP corrections before the multi-qubit correction for the concatenated-coded inner leafs simulating quantum memories, the number of multiplexing levels, the discard window for the resource generation, whether we simulate both inner and outer leafs and the number of simulation runs. The output of the function provides the ranked probabilities of logical X and logical Z flips for all the multiplexed links over such elementary links. Moreover, these probabilities are provided separately for the case where the measurement of the stabilisers for the [[7,1,3]] code on the inner leafs produced a zero-syndrome and a non-zero syndrome. Additionally the function also outputs the probabilities of the non-zero [[7,1,3]] code syndrome for the X and Z errors separately. Note that these are independent probabilities of X and Z flips, that is in the resulting Pauli channel the probability of the logical X would be the probability that there was an X flip but no Z flip etc.

The simulation is run through the function `SimulationRun.m` which is tailored to being run on the cluster as a job array so that one can easily call it for different configurations of hardware parameters. The function makes sure that the simulation runs until a desired accuracy level is obtained. The function `SimulationRun.m` focuses on a fixed number of multiplexing levels. Additionally, the function `SimulationRunVaryMultiplexing.m` runs the simulation when varying the number of multiplexing levels. The script `SimulationRunVaryMultiplexingOnlyPerfectOuter.m` runs a simplified version of `SimulationRunVaryMultiplexing.m` for the scenario where the inner leafs are assumed to be stored in perfect quantum memories (i.e. they are not being simulated) and all the hardware parameters are perfect, i.e. the only noise comes from losses in the communication channel for the outer leafs.

### Simulation Resources

The main script in this section is `SimulationResources' which simulates the probability of being able to generate required number of cube resource states in a single repeater given the available number of GKP qubits.

### DataAnalysis

In this folder we have tools targeting 5 tasks:

The folder `RatesAndAchievableDistances` includes functions that allow for calculating the rates and achievable distances of our scheme as a function of distance. Since binning the rates based on the inner leaf info is an intensive calculation (generally to be run on the cluster), there are 2 scripts for calculating the rate depending on the considered repeater separation and expected distances.

1. The script `SecretKeyVsDistArrayAndAchievableDistance10000.m` should be used for calculating rates for parameter configurations for which we expect large achievable distances, i.e. close to 10000 km and for which the repeater separation is rather small hence leading to large number of bins for larger distances. This function calculates the rate for all distances between 0 and 10000 km for a single parameter configuration.

2. The script `SecretKeyVsDistArrayAndAchievableDistanceParameterScan.m` should be used for calculating rates for parameter ranges for which expected achievable distances are much smaller than 10000 km or if we consider larger repeater separation. The function calculates the rates from 0 to 1000 km and then evaluate the achievable distances. If the achievable distance is in this range is 1000 km, it recalculates the rate from 0 to 2000 km and so on until the achievable distance no longer corresponds to the upper limit of the given distance interval.

All the rates vs distance can then be plotted using script `PlotSecretKeyVSDistance.m`.

The folder `RankingVsPostselection` includes tools to calculate the rate of only the outer leafs for comparing the performance of our novel ranking strategy with the possible post-selection based strategy. The ranking strategy requires data simulated for the case when the inner leafs are assumed to be perfect, while the post-selection strategy can be modelled analytically and so the included scripts already estimate the rate for that strategy. Once the data for the ranking strategy have been obtained, one can directly run the function `PlotAnalyticVsNumericComparisonOnlyOuter.m` to obtain a comparison plot between the rate for the ranking strategy and the post-selection strategy vs number of multiplexed links.

The folder `InnerLeafInfoAndTypicalSequences` includes tools to analyse the benefits of using the inner leaf information. Specifically, the `SecretKeyVsDistArray.m` can be used to generate the rate vs distance data for a specific configuration when we do and do not use the analog information. These data can then be plotted using `PlotSecretKeyVSDistance.m`. Additionally we can also generate the data when we use the inner leaf information but use only specific typical sequences. The rates vs distance data for differently defined typical sets can be calculated using the script `SecretKeyVsDistArrayTypicalSequencesZScan.m`. Then the rates vs distance plots for these different typical sets can be plotted using `PlotSecretKeyVSDistanceTypicalSequences.m` while the probabilities of being outside the typical set using `PlotProbabilitiesOutOfTypicalSequences.m`

The folder `CostFunctionOptimisation' includes the script `CostfunctionEvaluate.m' allowing to combine the performance data and the resource data in order to minimise the cost function and obtain the optimal repeater spacing, optimal resources in total and per repeater as well as the optimal rate

Finally the folder AnalyticalModelRate has tools allowing for analytical modelling of the error rate of the inner leafs in our repeaters. The key function is `RescaleLtottoE.m' which can be used to rescale/convert the total communication distance into an error rate according to our analytical model. Additionally the error rate can also be modelled using the function `AvErrorPerRepeater.m'.

The *Matlab* scripts make use of the following functions:

Adam Danz (2018). supersizeme (https://www.mathworks.com/matlabcentral/fileexchange/67644-supersizeme), MATLAB Central File Exchange. Retrieved November 19, 2020.

Jos 10584 (2018) allcomb (https://www.mathworks.com/matlabcentral/fileexchange/10064-allcomb-varargin), MATLAB Central File Exchange. Retrieved February 10, 2022.
 