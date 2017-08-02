#!/usr/bin/env perl

use strict;
use warnings;
use lib "lib";
use URI;
use Web::Scraper;
use open ':std', ':encoding(UTF-8)';

my $uri  = URI->new("http://www.zvornikdanas.com/category/vijesti/zvornik-3/");

my $zvornikNews = scraper {
    process 'div.bp-entry',
        'news[]' => scraper {
            process 'div.bp-head > h2 > a',   url => '@href', title => 'TEXT';
            process 'div.mom-post-meta > span', date => 'TEXT';
        };
    result 'news';
};

my $news = $zvornikNews->scrape($uri);

use YAML;
warn Dump $news;
