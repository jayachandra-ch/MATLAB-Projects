----------------------------------------------------------------
 Matlab tools for "A Computational Model of Visual Attention" 2017

 Jayachandra Chilukamari
 
 Copyright (c) 2017 Robert Gordon University
 
 Contact: Jayachandra Chilukamari at <j.chilukamari@rgu.ac.uk>
----------------------------------------------------------------

--------
Contents
--------

This code package includes the following files:

- calcCCscore.m is the code to measure the linear relationship between two variables. The value of CC lies in the [-1, 1] interval. When the value is close to +1/-1 there is a perfect linear relationship between the Ground truth fixation map and visual attention map. A value of 1 indicates that both the maps are similar. A value of 0 indicates that both the maps are totally different. A value of -1 indicates that both the maps are anti-correlated, i.e. a salient feature in one of the maps is completely non salient in the other map.

- calcNSSscore.m is the code to compute the average of the response values at human eye positions in a model’s saliency map that has been normalised to have zero mean and unit standard deviation. An NSS value greater than  or equal to one indicates that there are significantly higher saliency values at the human fixated locations in the saliency map. The higher the value, the better is the performance of the saliency model in predicting human fixations. An NSS value of zero indicates that the model performs no better than the random model and it mostly predicts the salient locations by chance. A value less than zero indicates that the model is predicting non-salient locations as salient.

- calcAUCscore.m is the code to calculate the Area Under Receiver operating Characteristic (AUC) curve. The main arguments for the function are saliency map, raw eye tracking map and number of random points sampled from shufflemap (default: 100). AUC is used as the global indicator of the model’s performance by considering all images of the dataset. A perfect prediction of the salient locations gives a score of 1 for AUC. A score of 0.5 indicates a chance level. A good saliency model AUC should lie between 0.5 and 1 and close to 1 for better performance. 

- auc.m returns the area under the curve by sweeping a threshold through the min and max values of the entire dataset. The function has two main arguments a and b. Argument 'a' is the model to test and 'b' is the random model to discriminate/differentiate from.  A score 0f .5 is a model that cannot discriminate from the random distribution.  


----------------------------------------------------------------
Send feedback, suggestions and questions to Jayachandra Chilukamari at <j.chilukamari@rgu.ac.uk>