<h1 align = "center"> VehiTrack </h1>
<h2 align = "center"> Leveraging technology to speed up the process of tracking down criminals in vehicles. </h2>

<h4> Our Team - DataFarmers </h4>
<ul>
	<li>Susmit Vengurlekar</li>
	<li>Rounak Tadvi</li>
	<li>Parth Waidya</li>
	<li>Ishan Vatsaraj</li>
</ul>

<h4> Cloud Branch </h4>
<p>This branch contains code files that are executed on AWS Lambda. </p>
<ul>
	<li>compare_fv.py</li>
	<p>This file contains the code to compare feature vector of the selected vehicle with the feature vectors of queried vehicles. The feature vectors of vehicles are compared using cosine similarity. The threshold is set so as to obtain maximum accuracy. The file is executed as an API which takes in the request information regarding the selected vehicle and queried vehicles. It then fetches the feature vectors stored in Amazon S3 Bucket and compares them. It returns a list of vehicle ids which have features similar to the selected vehicle.</p>
</ul>