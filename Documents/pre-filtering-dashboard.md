<form action="/dashboards/njH7xfrwTlIRrzoiP7DVpU" method="get">
<h2><center>Feasibility Count Request</center></h2>
<input type="hidden" name="run" value="1" />
<div style="display:flex">
  <div style="margin:0 1em">
    <input type="text" id="myform-client_name" name="Client Name" /><br />
    <label for="myform-code_1" style="color:#AAA;font-size:0.8em">Client Name</label>
  </div>
  <br />
  <div>
    <input type="text" id="myform-cpt" name="CPT Code" /><br />
    <label for="myform-cpt" style="color:#AAA;font-size:0.8em">CPT Code</label>
  </div>
  <br />
  <div>
    <input type="text" id="myform-ndc" name="NDC Code" /><br />
    <label for="myform-ndc" style="color:#AAA;font-size:0.8em">NDC Code</label>
  </div>
  <div>
    <input type="text" id="myform-icd_diagnosis_9" name="ICD Diagnosis 9" /><br />
    <label for="myform-icd_diagnosis_9" style="color:#AAA;font-size:0.8em">ICD Diagnosis 9</label>
  </div>
  <div style="margin:0 1em">
    <input type="date" id="myform-date" name="Service Date" /><br />
    <label for="myform-date" style="color:#AAA;font-size:0.8em">Date</label>
  </div>
  <div style="margin:0 1em">
   <input type="submit" value="Go" name="" style="height:2em" />
  </div>
</div>
<details>
  <summary>More Options</summary>
  <table>

  <tr><td><label for="myform-opt0">Datetime: </label></td>
  <td><input type="datetime-local" id="myform-opt0" name="My_Datetime" /></td></tr>
  <tr><td><label for="myform-opt1">Month: </label></td>
  <td><input type="month" id="myform-opt1" name="My_Month" /></td></tr>
  <tr><td><label for="myform-opt2">Number: </label></td>
  <td><input type="number" id="myform-opt2" name="My_Number" min="1" step="1" max="10" /></td></tr>
  <tr><td><label for="myform-opt3">Range: </label></td>
  <td><input type="range" id="myform-opt3" name="My_Range" /></td></tr>
  <tr><td><label for="myform-opt4">Email: </label></td>
  <td><input type="email" id="myform-opt4" name="My_Email" /></td></tr>
  <tr><td><b>Pick one:</b></td>
  <td>
  <input type="radio" id="myform-mode-day" name="Mode" value="d" checked="checked" />
  <label for="myform-mode-day" >Day</label> &nbsp;
  <input type="radio" id="myform-mode-week" name="Mode" value="w" />
  <label for="myform-mode-week">Week</label> &nbsp;
  <input type="radio" id="myform-mode-month" name="Mode" value="m" />
  <label for="myform-mode-month">Month</label>
  </td></tr>
  <tr><td><b>Pick any:</b></td>
  <td>
  <input type="checkbox" id="myform-check-a" name="Checks" value="web" checked="checked" />
  <label for="myform-check-a" >Web</label> &nbsp;
  <input type="checkbox" id="myform-check-b" name="Checks" value="android" checked="checked"  />
  <label for="myform-check-week">Android</label> &nbsp;
  <input type="checkbox" id="myform-check-c" name="Checks" value="ios" checked="checked"  />
  <label for="myform-check-c">iOS</label>
  </td></tr>
</details>
</form>
