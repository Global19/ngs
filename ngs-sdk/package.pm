sub PACKAGE      { 'ngs-sdk' }
sub VERSION      { '1.0.0' }
sub PACKAGE_TYPE { 'L' }
sub PACKAGE_NAME { 'NGS-SDK' }
sub PACKAGE_NAMW { 'NGS' }
sub CONFIG_OUT   { '.' }
sub PKG { ( LNG   => 'C',
            OUT   => 'ncbi-outdir',
            PATH  => '/usr/local/ngs/ngs-sdk',
            UPATH =>      '$HOME/ngs/ngs-sdk', ) }
sub REQ {}
1
