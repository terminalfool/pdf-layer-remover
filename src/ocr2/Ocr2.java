package ocr2;

import java.io.FileOutputStream;
import java.io.IOException;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.ocg.*;

class Ocr
    {
        public static void remove_layers(String[] args) throws IOException, DocumentException {
        		String inFile = args[0];
           		String outFile = inFile;
        		outFile = outFile.replaceAll("_geo", "_gps");
        		PdfReader reader = new PdfReader(inFile);
        		PdfStamper stamper = new PdfStamper(reader, new FileOutputStream(outFile));
        		new OCGRemover().removeLayers(reader, "Projection Coordinate Values", "Geographic and Grid Ticks", "Geographic and Grid Tics", "Grid Lines", "Hydrographic Features", "Hydrography Features", "Land Cover");
        		stamper.close();
        }
    }
