#!/usr/local/bin/perl

BEGIN {
  $ENV{CLASSPATH} .= ":/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Classes/classes.jar:/Users/admin/java/wildcard-1.0.jar:/Users/admin/java/itext-5.4.4/itext-xtra-5.4.4.jar:/Users/admin/java/itext-5.4.4/itextpdf-5.4.4.jar";
}

use Inline (Java => <<'EOJ',
import java.io.FileOutputStream;
import java.io.IOException;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.ocg.*;

public class Ocr
    {
        public static void remove_layers(String arg) throws IOException, DocumentException {
        String inFile = arg;
        String outFile = inFile;
        outFile = outFile.replaceAll("_geo", "_gps");
        PdfReader reader = new PdfReader(inFile);
        PdfStamper stamper = new PdfStamper(reader, new FileOutputStream(outFile));
        new OCGRemover().removeLayers(reader, "Projection Coordinate Values", "Geographic and Grid Ticks", "Geographic and Grid Tics", "Grid Lines", "Hydrographic Features", "Hydrography Features", "Land Cover");
        stamper.close();
        }
    }
EOJ
CLASSPATH => $ENV{CLASSPATH},
);

use Archive::Zip;
use Inline::Java qw(caught);

#my @dir = '/users/admin/apache/vhosts/maps/_h5ai/cache';
my $dir = '/users/admin/desktop';
my @processlist = ();

for (glob("$dir/*.zip")) {
  my $zip = Archive::Zip->new($_);
  foreach my $member ($zip->members) {
    my $extractName = $member->fileName;
    if ($extractName =~ /\.pdf/i) {
      $member->extractToFileNamed("$dir/$extractName");
      push @processlist, "$dir/$extractName";
    }
  }
  unlink $_;
}

foreach (@processlist) {
  eval {
    my $javaOcrObj = new Ocr();
    my $returnStr = $javaOcrObj->remove_layers($_);
  };
return $returnStr if $returnStr;
}
