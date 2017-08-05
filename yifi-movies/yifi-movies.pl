#!/usr/bin/env perl

use strict;
use warnings;
use lib "lib";
use URI;
use Web::Scraper;
use open ':std', ':encoding(UTF-8)';
use Term::ANSIColor;

my $uri  = URI->new("https://yts.ag/browse-movies");

my $yifiMovies = scraper {
    process 'a.browse-movie-link',
        'yifiMovies[]' => scraper {
            process 'a', url => '@href';
            process 'img.img-responsive', title => '@alt';
            process 'h4.rating', rating => 'TEXT';
            process 'h4:nth-of-type(2)', genre => 'TEXT'
        };
};

# Format movie output
sub format_movie {
    my ($title, $rating, $genre, $url) = @_;

    # Remove the download word in title
    $title =~ s/ download//;

    print color("red"), "\n*) $title\n", color("reset");
    print color("green"), "$genre", color("yellow"),"\t$rating\n",color("reset");
    print "$url\n";
}

my $movies = $yifiMovies->scrape($uri);

for my $movie (@{$movies->{yifiMovies}}){
    format_movie($movie->{title}, $movie->{rating}, $movie->{genre}, $movie->{url});
}
