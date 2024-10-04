#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 3;

BEGIN {
    use_ok( 'Misskey::Client' ) || print "Bail out!\n";
    use_ok( 'Misskey::Account' ) || print "Bail out!\n";
    use_ok( 'Misskey::Meta' ) || print "Bail out!\n";
}

diag( "Testing Misskey::Client $Misskey::Client::VERSION, Perl $], $^X" );
