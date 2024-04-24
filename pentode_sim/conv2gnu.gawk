BEGIN {
  print "convert raw spice data to gnuplot";
	state = "";
  lineNo = 0;
  outfile = "data.dat";
  dataSet = 0;
  TRUE = 1;
  FALSE = 0;
  voltsSF = 1;       ## scale conversion for volts
  currentSF = -1000; ## scale conversion for current
  
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
	
	state = "Values";
  
  dataHeader = TRUE;
   ## print "Debug -- state is VALUES";
	next;
}

($0 && state == "Vars") {
 ##print "Debug -- in vars";
	varName[$1] = $2;
  
  ## get var type set scale factor 
  if( $3 == "current" ) {
      varSF[$1] = currentSF;# convert to mAs
   }
   
  if( $3 == "voltage" ) {
      varSF[$1] = voltsSF;   # scale factor 1
  }
	next;
}

(state == "Values" && $1 ~ "Title:" ) {
  state = "inHeader";
  next;
}

(state == "Values") {
  
  if( NF > 0 )  ## skip blank lines
  {
      pltLine[lineNo] = $2*varSF[0];   ##sweep var

      for( vectNo = 1; vectNo < noOfVars; vectNo++ ) {

          if((getline tmp ) > 0 ) { ## read next line 
              pltLine[lineNo] =  pltLine[lineNo] " " tmp*varSF[vectNo];
              if(vectNo == 1 )   ## get the step variable value
                 stepVarValue = tmp;
          }
          else
              print " File read exit"
      }
      
      if(dataHeader) {
         printf("\n\n_%s_\\%d\n", varName[1],stepVarValue) > outfile;
         dataHeader = FALSE;
      } 
      print lineNo " " pltLine[lineNo] > outfile;
      
      lineNo++;
  }
	next;
}

END {  
  print "Plot size " lineNo " written to " outfile;
	
}