use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'CGI::Application::Plugin::DevPopup',
    AUTHOR              => 'Rhesa Rozendaal <rhesa@cpan.org>',
    VERSION_FROM        => 'lib/CGI/Application/Plugin/DevPopup.pm',
    ABSTRACT_FROM       => 'lib/CGI/Application/Plugin/DevPopup.pm',
    LICENSE             => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
		'CGI::Application'	=> 4.01,
		'Time::HiRes' => 0,
        'HTML::Template' => 0,
        'IO::Scalar' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'CGI-Application-Plugin-DevPopup-*' },
);
