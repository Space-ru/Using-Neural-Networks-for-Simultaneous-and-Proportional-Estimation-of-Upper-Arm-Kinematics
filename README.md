# Using-Neural-Networks-for-Simultaneous-and-Proportional-Estimation-of-Upper-Arm-Kinematics
Contributors: Christian Grech, Tracey Camilleri and Marvin Bugeja


This work compares the use of three different artificial neural networks (ANNs) to estimate shoulder and elbow kinematics using surface electromyographic (EMG) signals for proportional and simultaneous control of multiple degrees of freedom (DOFs). The three different networks considered include a multilayer perceptron (MLP) neural network, a time delay neural network (TDNN), and a recurrent neural network (RNN). In each case, surface EMG signals from agonist and antagonist arm muscles detected during seven  different movements, three of which involve the simultaneous activation of the shoulder and elbow, were used as inputs to the neural networks. The three configurations were trained to estimate angular displacements of the shoulder and/or elbow. The average correlation coefficient (CC) between the true and the estimated angular position for simultaneous movements for the elbow and shoulder combined was 0.866 ± 0.050 when using the MLP structure, 0.830 ± 0.130 for the TDNN structure and 0.840 ± 0.058 when using the RNN architecture. These results show that all three neural networks are plausible alternatives to model the EMG to joint angle relationship of the upper arm with the MLP being the most computationally efficient option.


The code and data are organized per subject (S1 to S5) for convenience rather than efficiency. The structure is:
* Subject (1 to 5)
** Model (MLP, TDNN, RNN)
*** Movement (Elbow, ShoulderXY, ShoulderXZ, Shoulder YZ, SimultaneousYZ, SimultaneousXY, SimultaneousXZ)

Hence all data/code for [Subject 1/MLP/Elbow] is in that particular folder and not dependent on other folders.

The pipeline is as follows:
1. Extract_EMG_position.m: from the raw data (in some cases unavailable) extract EMG data and VICON positions. The joint angle is calculated and all data is stored in TestTrial.mat files (one file per trial).
2. Preprocessing_EMG.m: TestTrial files are processed where different features are calculated for the EMG signal (ex: RMS, normalization). Files are then stored as FeaturesTrials.mat (one file per trial).
3. mlp_app_cross.m: FeaturesTrials.mat files are used as inputs in a crossvalidation format and results presented in a table.

Other MATLAB scripts are there for testing purposes and analysis, including different crossvalidation strategies.
