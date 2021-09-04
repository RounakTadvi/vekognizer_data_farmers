<h1 align = "center"> Vekognizer </h1>
<h2 align = "center"> Leveraging technology to speed up the process of tracking down criminals in vehicles. </h2>

<h4> Our Team - DataFarmers </h4>
<ul>
	<li>Susmit Vengurlekar</li>
	<li>Rounak Tadvi</li>
	<li>Parth Waidya</li>
	<li>Ishan Vatsaraj</li>
</ul>

<h3>Project Structure</h3>
<p>The code of our project is divided into 3 separate branches namely <b>cloud, data_collection, and frontend</b>. We believe that keeping the code separated on different branches helps in efficient development of the product. It also helps in finding and fixing bugs. </p>

<h4> cloud Branch </h4>

>High Processing Power + Low Latency => Faster App Execution!


<p>This branch contains the <b>code files executed on AWS Lambda</b>. Following functions are performed by the code files in this branch: </p>
<ul>
	<li><b>Execute the code files as an API</b> which takes in the request information containing details of the selected vehicle and queried vehicles. </li>
	<li><b>Fetch the feature vectors</b> stored in Amazon S3 Bucket. </li>
	<li><b>Compare the feature vectors</b> of queried vehicles with the feature vector of the selected vehicle using cosine similarity. </li>
	<li><b>Return list of vehicle ids</b> which have features similar to the selected vehicle. </li>
</ul>

<h4> data_collection Branch </h4>

>Enormous Data + Efficient Collection and Storage => Accurate Predictions!!

<p>This branch is the <b>BRAIN</b> of the project. Following functions are performed by the code files in this branch: </p>
<ul>
	<li><b>Fetch live stream video data</b> from multiple signals. </li>
	<li><b>Detect and Extract Vehicle attributes</b> like color, type, etc. </li>
	<li><b>Store the extracted data on AstraDB</b> along with timestamp and location of vehicle.</li>
	<li>Store the extracted feature vectors and vehicle images in <b>Amazon S3 bucket</b>. </li>
</ul>

<h4> frontend Branch </h4>

>Elegent Design + Awesome UI/UX => Great Product!!!

<p> This branch contains <b>the code which gives the app its looks!</b> Following functions are performed by the code files in this branch: </p>
<ul>
	<li><b>Display a form to enter information about crime</b>. i.e. Date, Location, Vehicle Attributes, etc. </li>
	<li><b>Send this data to the backend(AstraDB, AWS Lambda, Amazon S3)</b> for further processing. </li>
	<li><b>Display the vehicle details</b> fetched from backend.</li>
	<li><b>Display the possible route taken by the vehicle on Google Maps</b> after successfully selecting one vehicle. </li>
</ul>

<h3>Tech Stack</h3>
<ul>
	<li><b>Frontend</b>: Flutter Web</li>
	<li><b>Backend</b>: AstraDB, AWS Lambda, Amazon S3</li>
	<li><b>Deep Learning and other Processing</b>: Python</li>
	<li><b>Deployment and Hosting</b>: Firebase Hosting</li>
	<li><b>Other API</b>: Google Maps API</li>
</ul>