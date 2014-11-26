import processing.pdf.*;
PFont bebas, mono;
Table data, data_g;
TableRow nrow, nrow_g;
PImage template, template_g;
int numRows, numRows_g, cr = 0;

// national numbers
float natl_unc_rev, natl_for_rev;
String natl_unc_rev_growth, natl_for_rev_growth;


void setup() {
  smooth();
  size(612, 792);
  bebas = createFont("BebasNeue Bold.otf", 30);
  mono = createFont("Mono45Headline.otf", 23);
  data = loadTable("mitfa.tsv", "header");
  data_g = loadTable("mitfa_grandfathered.tsv", "header");
  numRows = data.getRowCount();  
  numRows_g = data_g.getRowCount();  
  nrow = data.getRow(numRows - 1);
  nrow_g = data_g.getRow(numRows_g - 1);
  template = loadImage("MITFA_MEDforgone_comma.png");
  template_g = loadImage("MITFA_MED_grandfathered_comma.png");
  
  // test case
  //buildProfile(data.getRow(0));
}

void draw() {
  if (cr < numRows - 1) {
    buildProfile(template, data.getRow(cr), nrow, false);
  } else {
    buildProfile(template_g, data_g.getRow(cr - (numRows - 1)), nrow_g, true);    
  }
  
  cr++;
  if (cr == numRows + numRows_g - 2) exit();
}

void buildProfile(PImage template, TableRow row, TableRow nrow, boolean isGrand) {
  String stateName = row.getString("StateName");
  beginRecord(PDF, "/profiles_med/MITFA_" + row.getString("State") + ".pdf");

  background(255);
  image(template, 0, 0, 612, 792);
  
  fill(0);
  textAlign(LEFT, CENTER);
  textFont(bebas);
  text(stateName, 27, 240);
  
  
  /* ---- Get Numbers ---- */
  float unc_rev = row.getFloat("unc_revenue");
  String unc_rev_growth = row.getString("unc_revenue_growth");
  float for_rev = row.getFloat("for_revenue");
  String for_rev_growth = row.getString("for_revenue_growth");

  float natl_unc_rev = nrow.getFloat("unc_revenue");
  String natl_unc_rev_growth = nrow.getString("unc_revenue_growth");
  float natl_for_rev = nrow.getFloat("for_revenue");
  String natl_for_rev_growth = nrow.getString("for_revenue_growth");

  
  /* ---- Text Placement ---- */  
  int yPos1 = 319, yPos2 = 350;
  int xPos1 = 179, xPos2 = 296, xPos3 = 442, xPos4 = 558;
  
  textFont(mono);
  fill(0, 153, 204);
  textAlign(RIGHT, CENTER);
  text(formatFloat(unc_rev), xPos1, yPos1);
  text(formatPercent(unc_rev_growth), xPos2, yPos1);
  text(formatFloat(for_rev), xPos3, yPos1);
  text(formatPercent(for_rev_growth), xPos4, yPos1);

  /*fill(0);
  text(formatFloat(natl_unc_rev), xPos1, yPos2);
  text(formatPercent(natl_unc_rev_growth), xPos2, yPos2);
  text(formatFloat(natl_for_rev), xPos3, yPos2);
  text(formatPercent(natl_for_rev_growth), xPos4, yPos2);*/
  
  endRecord();
}

String formatFloat(float val) {
  String str = nf(val, 0, 1) + " M";
  if (val > 1000) str = nf(val/1000, 0, 1) + " B";
  if (str.length() < 7) {
    for (int k = str.length(); k < 7; k++) str = " " + str;
  }
  return "$" + str;
}
String formatPercent(String str_val) {
  float val = Float.parseFloat(str_val.substring(0, str_val.length() - 1));
  return nf(val, 0, 1) + "%";
}
