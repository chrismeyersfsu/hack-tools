#!/usr/bin/perl

# Usage: 
# curl --data-urlencode "hello world()" google.com --trace-ascii - 2>/dev/null | ./parse_post.pl
# curl --data-urlencode "hello world()" localhost --trace-ascii - 2>/dev/null | ./parse_post.pl

# Often times you want to encode data.  This is problematic from the command
# line.  To deal with this, curl supports encoding from file
# curl --data-urlencode @parse_post.pl google.com --trace-ascii - 2>/dev/null | ./parse_post.pl
# curl --data-urlencode @parse_post.pl localhost --trace-ascii - 2>/dev/null | ./parse_post.pl

@lines = <STDIN>;
chomp(@lines);

my $str = '';

my $flag_found = 0;
foreach my $line (@lines) {
	if ($flag_found == 0) {
		if ($line =~ "Send data") {
			$flag_found = 1;
		}
		next;
	}

	# flag_found is 1 if we are here
	my $data;
	($data) = $line =~ /^[0-9a-f]+\: (.*)/;
	if (!$data) {
		last;
	}

	$str .= $data;
}
print $str;
