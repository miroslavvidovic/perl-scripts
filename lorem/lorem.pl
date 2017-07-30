#!/usr/bin/env perl

use Getopt::Long;
use Text::Lorem;
use Getopt::Long 'HelpMessage';

GetOptions(
  'words=i'        => \ my $words,
  'sentences=i'    => \ my $sentences,
  'paragraphs=i'   => \ my $paragraphs,
  'help'           =>   sub { HelpMessage(0) },
) or HelpMessage(1);

HelpMessage(1) unless ($words or $sentences or $paragraphs);

my $text = Text::Lorem->new();

if (defined $words) {
    $lorem_words = $text->words($words);
    print "$lorem_words \n"
} 
if (defined $sentences) {
    $lorem_sentences = $text->sentences($sentences);
    print "$lorem_sentences \n"
}
if (defined $paragraphs) {
    $lorem_paragraphs = $text->paragraphs($paragraphs);
    print "$lorem_paragraphs \n"
}

sub lorem { ... }

=head1 NAME

lorem - generate some lorem ipsum text

=head1 SYNOPSIS

  --words,-w            Number of paragraphs
  --sentences,-s        Number of sentecese
  --paragraphs,-p       Number of paragraphs
  --help,-h             Print this help

=head1 VERSION

0.01

=cut
