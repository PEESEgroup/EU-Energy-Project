# EU-Energy-Project
This study investigates strategic scenarios driven by renewable capacity expansion and incorporates the strategies of electrification, green hydrogen deployment, and carbon offsetting to align EU energy security with the long-term imperative of climate change mitigation. The following contents are included in this repository to support our key findings:
-	Codes: include all codes to evaluate the strategic scenarios.
-	Data: include all data used during the analysis.
## Data Files
The input data files contain scenario-specific parameters used in the modeling framework. These include renewable generation profiles such as solar radiation (EU_rad.xlsx, DE_NUTS2.xlsx), wind power output (EU_wpo.xlsx), cost projections for technologies including solar (inp_solar_cpx.xlsx, inp_solar_opx.xlsx), wind (inp_wind_cpx.xlsx, inp_wind_opx.xlsx), battery storage and interface systems (inp_bst_cpx.xlsx, inp_bst_opx.xlsx, inp_bit_cpx.xlsx, inp_bit_opx.xlsx), electrolyzers (inp_elec_cpx.xlsx), DAC systems (inp_dac_cpx.xlsx), heat pumps (inp_hp_cpx.xlsx), specifications for hydrogen pipeline infrastructure (inp_hyd_length.xlsx, inp_hpipe_cpx.xlsx, inp_hpipe_opx.xlsx ), and energy price assumptions across EU member states (inp_ele_price.xlsx and inp_ng_price.xlsx).

The output data files present estimates of natural gas displacement and avoided emissions across key sectors, including light industries (str1_part1_solar_LI, str1_part1_wind_LI), electricity and heating (str1_part2_solar_EH, str1_part2_wind_EH), and road transport (str1_part3_solar_RT, str1_part3_wind_RT) for the electrification strategy (alongside frequency distributions of net load ramp rates in str1_part4_NLRR); heavy industries and heavy trucks (str2_part1_solar_HI, str2_part1_wind_HI) for green hydrogen deployment; and carbon offsetting contributions (str3_part1_solar_CC, str3_part1_wind_CC), under the investigated scenarios and time horizons across EU member states.
## Code files
The repository includes code files used to implement the scenario-based modeling framework applied in this study. These files reflect the different cases evaluated across the renewable technology scenarios and associated transition strategies:
-	str1_elec_solar
-	str1_elec_wind
-	str2_hyd_solar
-	str2_hyd_wind
-	str3_dac_solar
-	str3_dac_wind
## Citation
Please use the following citation when using the data, methods or results of this work:
> Lal, A., Tavoni, M., Preuss, N., and You, F. Aligning EU Energy Security and Climate Mitigation Through Targeted Transition Strategies. Submitted to Nature Communications.
