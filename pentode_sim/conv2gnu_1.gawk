BEGIN {
  print "convert raw spice data to gnuplot";
	state = "";
  lineNo = 0;
  outfile = "data.dat";
  dataSet = 0;
  
}

($1 ~ "Title:") {
  state = "inHeader"
   ##printf("\n\n##data plot %d\n", dataSet++) > outfile;
  next;
}

(state == "inHeader" && $2 ~ "Variables:") {
	noOfVars =$3;
		next;
	##print"debug: found " noOfVars " vars " ;

}


(state == "inHeader" && $2 ~ "Points:") {

	noOfPoints =$3;
	##print"debug: found " noOfPoints " points " ;
	next;
}

(state == "inHeader" && $1 ~ "Variables:") {

	state = "Vars"
 ## print "Debug -- state is VARS";
	next;
}

(state == "Vars" && $1 ~ "Values:") {
	
	state = "Values"
   ## print "Debug -- state is VALUES";
	next;
}

(state == "Vars") {
	varName[$1] = $2;
	next;
}

(state == "Values" && $1 ~ "Title:" ) {
  state = "inHeader";
  next;
}

(state == "Values") {
  
  if( NF > 0 ) 
  {
      ##varPoint[$1] = $2;
      pltLine[lineNo] = $2;

      for( vectNo = 1; vectNo < noOfVars; vectNo++ ) {

          if((getline tmp ) > 0 ) { ## read next line 
              pltLine[lineNo] =  pltLine[lineNo] " " tmp;
          }
          else
              print " File read exit"
      }
     ## print "debug: line no " lineNo " is " pltLine[lineNo];
      lineNo++;
  }
	next;
}

END {
	## write out a gnuplot file 
  for( xx =0 ; xx < lineNo; xx++ ) {
    if( (xx % noOfPoints ) == 0 ) {
        ## get the step variable data set value
       printf("\n\ndataset_%d\n", dataSet++ ) > outfile;
    {
    print xx " " pltLine[xx] > outfile;
  }
  
  print "Plot size " lineNo " written to " outfile;
	
}