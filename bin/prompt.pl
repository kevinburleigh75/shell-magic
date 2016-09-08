#!/usr/bin/env perl

##
## Timestamp
##

my @fields = localtime();
my $timestampStr = sprintf("[%02d:%02d:%02d]", $fields[2], $fields[1], $fields[0]);

##
## Current Directory
##

my $cwd = `pwd -P`;
chomp $cwd;
my $cwdStr = $cwd;

##
## Current username
##

my $curUser = `whoami`;
chomp $curUser;

##
## Root warning
##

my $rootWarning = "";
$rootWarning = "(ROOT) "
  if $curUser eq "root";

##
## Current git branch (if any)
##

my $gitBranchStr = "";
my @gitBranchLines = `git branch 2> /dev/null`;
@gitBranchLines = grep(/^\s*\*\s/, @gitBranchLines);

if (scalar(@gitBranchLines) == 1) {
  $gitBranch = $gitBranchLines[0];
  $gitBranch =~ s/^\s+|\s+$//g;
  $gitBranch =~ s/\*\s+//g;
  $gitBranch =~ s/^\(|\)$//g;
  $gitBranchStr = "[" . $gitBranch . "] "
    if $gitBranch ne "";
}

##
## Python virtualenv (if any)
##

my $virtualenvStr = "";
if (defined($ENV{'VIRTUAL_ENV'})) {
  my $virtualenv = $ENV{'VIRTUAL_ENV'};

  $virtualenv =~ m!^(.*)/(.*)$!;
  my $virtualenvDir  = $1;
  my $virtualenvName = $2;

  my $virtualenvDanger = ($virtualenvName eq "kenv") && ($cwd !~ m!^$virtualenvDir(/|$)!);

  my $virtualenvDangerStr = "";
  $virtualenvDangerStr = " - DANGER" if $virtualenvDanger;

  $virtualenvStr = "{" . $virtualenvName . $virtualenvDangerStr . "} ";
}

##
## Font Attributes
##

## https://en.wikipedia.org/wiki/ANSI_escape_code
## http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html
## http://mywiki.wooledge.org/BashFAQ/053

# my $resetAttrs   = "\001\033[0m\002";
# my $boldStart    = "\001\033[1m\002";
# my $redStart     = "\001\033[31m\002";
# my $boldRedStart = "\001\033[1;31m\002";

my $resetAttrsSeq = `tput sgr0`;
chomp $resetAttrsSeq;
my $resetAttrs = "\001$resetAttrsSeq\002";

my $boldStartSeq = `tput bold`;
chomp $boldStartSeq;
my $boldStart = "\001$boldStartSeq\002";

my $redStartSeq = `tput setaf 1`;
chomp $redStartSeq;
my $redStart = "\001$redStartSeq\002";

my $boldRedStart = "\001$boldStartSeq$redStartSeq\002";

my $promptAttr = $boldStart;
$promptAttr = $boldRedStart
  if ($curUser eq "root");

##
## Construct Prompt
##

my $prompt = join("", $promptAttr, $rootWarning, $timestampStr,
                      " ",
                      $virtualenvStr, $gitBranchStr, $cwdStr,
                      " : ", $resetAttrs);

print STDOUT $prompt;
