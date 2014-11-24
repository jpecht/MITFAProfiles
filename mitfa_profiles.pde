import processing.pdf.*;
PFont font;
PShape template;
PImage logoImg;
Table data, data_g;
int numRows, numRows_g, cr = 0; // current row

float natl_unc_rev, natl_for_rev;
String natl_unc_rev_growth, natl_for_rev_growth;

void setup() {
  size(612, 792);
  font = createFont("BebasNeue Regular.otf", 32);
  //template = loadShape("template.svg");
  data = loadTable("mitfa.tsv", "header");
  data_g = loadTable("mitfa_grandfathered.tsv", "header");
  numRows = data.getRowCount();  
  numRows_g = data_g.getRowCount();  

  logoImg = loadImage("logo_small.png");

  smooth();

  // get national numbers
  TableRow nrow = data.getRow(numRows - 1);
  natl_unc_rev = nrow.getFloat("unc_revenue");
  natl_unc_rev_growth = nrow.getString("unc_revenue_growth");
  natl_for_rev = nrow.getFloat("for_revenue");
  natl_for_rev_growth = nrow.getString("for_revenue_growth");
  
  buildProfile(data.getRow(0));
}

void draw() {
  /*buildProfile(data.getRow(cr));
  cr++;
  if (cr == numRows - 1) exit();*/
}

void buildProfile(TableRow row) {
  String stateName = row.getString("State");
  beginRecord(PDF, "/profiles/" + stateName + ".pdf");

  background(255);
  //shape(template, 0, 0);
  //image(logoImg, 0, 0, 612, 583.2);
  
  fill(0);
  textAlign(LEFT, BOTTOM);
  textFont(font, 26);
  text(stateName, 27, 211);
  
  fill(0, 153, 204);
  textAlign(CENTER, BOTTOM);
  textFont(font, 24);
  float unc_rev = row.getFloat("unc_revenue");
  String unc_rev_growth = row.getString("unc_revenue_growth");
  float for_rev = row.getFloat("for_revenue");
  String for_rev_growth = row.getString("for_revenue_growth");

  
  /* ---- Text Placement ---- */  
  int yPos1 = 300;
  int yPos2 = 350;
  
  text(formatFloat(unc_rev), 100, yPos1);
  text(formatPercent(unc_rev_growth), 200, yPos1);
  text(formatFloat(for_rev), 300, yPos1);
  text(formatPercent(for_rev_growth), 400, yPos1);

  text(formatFloat(natl_unc_rev), 100, yPos2);
  text(formatPercent(natl_unc_rev_growth), 200, yPos2);
  text(formatFloat(natl_for_rev), 300, yPos2);
  text(formatPercent(natl_for_rev_growth), 400, yPos2);
  
  endRecord();
}

String formatFloat(float val) {
  String str = "$" + nf(val, 0, 1) + "M";
  if (val > 1000) str = "$" + nf(val/1000, 0, 1) + "B";
  return str;
}
String formatPercent(String str_val) {
  float val = Float.parseFloat(str_val.substring(0, str_val.length() - 1));
  return nf(val, 0, 1) + "%";
}
