class MIME::Base64::Perl {

    method encode_base64(Str $str) {
        return '' if $str eq '';

        # this should be stored at the class level
        my @table = 'A'..'Z','a'..'z',0..9,'+','/';

        # 6 bit packs padded with 0s at the LSB
        my $bit-string  = $str.comb(/./)>>.ord>>.fmt('%08b').join();
        my $bit-padding =  $bit-string.chars % 6;
        if $bit-padding != 0 {
            $bit-string ~= '0' x (6 - $bit-padding);
        }

        my @packs = $bit-string.comb(/....../);

        # build corresponding base64 characters from 6 bit packs
        my $output;
        for @packs -> $p {
            my @binary = $p.comb(/./);
            my @bases  = 2 X** ((^$p.chars).reverse);
            my $index  = ( [+] (@binary >>*<< @bases) );
            $output ~= @table[$index];
        }

        # pad with = chars if needed
        my $padding = $output.chars % 4;
        if $padding != 0 {
            $output ~= '=' x (4 - $padding);
        }

        return $output;
    }

    method decode_base64(Str $str) {
        die "Not yet implemented";
    }

}
