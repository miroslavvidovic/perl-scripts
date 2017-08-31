#!/usr/bin/env perl
 
use strict;
use warnings;
use lib "lib";
use URI;
use Web::Scraper;
use open ':std', ':encoding(UTF-8)';
use Term::ANSIColor;

my $uri  = URI->new("http://partizan.rs/pocetna/?pismo=lat");

my $partizan = scraper {
    process 'div.tab-content',
        'partizan[]' => scraper {
            process 'strong', game => 'TEXT';
            process 'div.tab-pane', info => 'TEXT';
        };
};

sub format_game {
    my ($game, $info) = @_;

    # Remove the game text in info
    $info =~ s/$game//;

    print color("green"), "\n => $game\n", color("reset");
    print "$info\n\n" ;
}

my $matches = $partizan->scrape($uri);

for my $match (@{$matches->{partizan}}){
    format_game($match->{game}, $match->{info});
}
