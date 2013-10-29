package ocr;

import java.io.FileOutputStream;
import java.io.IOException;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.ocg.*;
import com.esotericsoftware.wildcard.Paths;

class Ocr
    {
        public static void main(String[] args) throws IOException, DocumentException {
        	Paths paths = new Paths();
        	paths.glob("/Users/admin/Desktop/", "*_geo.pdf");
        	for (String inFile : paths.getPaths()) {
           		String outFile = inFile;
        		outFile = outFile.replaceAll("_geo", "_gps");
        		PdfReader reader = new PdfReader(inFile);
        		PdfStamper stamper = new PdfStamper(reader, new FileOutputStream(outFile));
        		new OCGRemover().removeLayers(reader, "Projection Coordinate Values", "Geographic and Grid Ticks", "Geographic and Grid Tics", "Grid Lines", "Hydrographic Features", "Hydrography Features", "Land Cover");
        		stamper.close();
        	}
        }
    }
