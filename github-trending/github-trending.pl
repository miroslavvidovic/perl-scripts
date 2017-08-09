#!/usr/bin/env perl

use strict;
use warnings;
use lib "lib";
use URI;
use Web::Scraper;
use Term::ANSIColor;
use Text::Wrap;
use Getopt::Long;
use Getopt::Long 'HelpMessage';

# my ($weekly, $daily, $monthly) = " ";

GetOptions(
  'language=s'  => \ my $language,
  'daily'       => \ my $daily,
  'weekly'      => \ my $weekly,
  'monthly'     => \ my $monthly,
  'help'        =>   sub { HelpMessage(0) },
) or HelpMessage(1);

HelpMessage(1) unless ($language);
HelpMessage(1) unless ($daily or $weekly or $monthly);

sub set_time(){
    if (defined $daily) {
        return "daily";
    } elsif (defined $weekly) {
        return "weekly";
    } elsif (defined $monthly) {
        return "monthly";
    }
}

my $time = set_time();

my $uri = URI->new("https://github.com/trending/$language?since=$time");

my $trendingRepositories = scraper {
    process 'li.col-12',
        'trendingRepositories[]' => scraper {
            process 'a', url => '@href';
            process 'a', name => 'TEXT';
            process 'div.py-1', description => 'TEXT';
            process 'a.muted-link:nth-of-type(1)', totalStars => 'TEXT';
            process 'a.muted-link:nth-of-type(2)', forks => 'TEXT';
            process 'span.float-sm-right', recentStars => 'TEXT';
        };
};

sub separator {
    my ($character, $numOfTimes) = @_;
    for (1..$numOfTimes){print $character;}
}

# Format output
sub print_format {
    my ($url, $name, $description, $totalStars, $recentStars, $forks) = @_;

    if (!defined $recentStars) {
        $recentStars = " ";
    } 

    separator("-", 80);

    print color("blue"),"\n$name\t", color("reset"), color("red"), "$recentStars\n";
    print color("yellow")," Total stars:$totalStars \t  Forks:$forks\n", color("reset");

    # Wrap the description text to 80 characters
    $Text::Wrap::columns = 80;
    print wrap('', '',$description) . "\n";

    print color("green"),"$url\n", color("reset");
}

my $repositories = $trendingRepositories->scrape($uri);

for my $repository (@{$repositories->{trendingRepositories}}){
    print_format($repository->{url}, $repository->{name}, $repository->{description},
        $repository->{totalStars}, $repository->{recentStars}, $repository->{forks});
}

=head1 NAME

github-trending - web scraper for github trending

=head1 SYNOPSIS

  --language,-l                                 Programming language
  --daily, -d | weekly, w | monthly, m          Time frame(week, month or day)
  --help,-h                                     Print this help

=head1 VERSION

0.01

=cut
