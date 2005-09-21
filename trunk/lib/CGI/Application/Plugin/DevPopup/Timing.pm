package CGI::Application::Plugin::DevPopup::Timing;

use base qw/Exporter/;
use Time::HiRes qw/gettimeofday tv_interval/;
my $start = [gettimeofday];

our $VERSION = '0.01';

sub import
{
    my $c = scalar caller;
    $c->add_callback( 'devpopup_report', \&_timer_report );
    foreach my $stage (qw/ init prerun load_tmpl /)
    {
        $c->add_callback( $stage, sub { _add_time( shift(), $stage, @_ ) } );
    }
    goto &Exporter::import;
}

sub _timer_report
{
    my $app = shift;

    my $self = _new_or_self($app);
    unshift @$self, { dec => 'start', tod => $start };
    _add_time( $app, 'postrun' );
    $app->devpopup->add_report(
        title   => 'Timings',
        summary => 'Total runtime: ' . tv_interval( $self->[1]{tod}, $self->[-1]{tod} ) . 'sec.',
        report  => '<ul><li>Application started at: ' . scalar( localtime( $start->[0] ) ) . '</li>' .
			join(
				$/,
				map {
					my $stage = $self->[$_]{desc} . ' -&gt; ' . $self->[ $_ + 1 ]{desc};
					my $time = tv_interval( $self->[$_]{tod}, $self->[ $_ + 1 ]{tod} );
					"<li>$stage: $time sec.</li>"
				  } ( 1 .. $#$self-1 )
			  )
          . '</ul>'
    );
}

sub _add_time
{
    my $app   = shift;
    my $stage = shift;
    my $self  = _new_or_self($app);
    push @$self, { desc => $stage, tod => [gettimeofday] };
}

sub _new_or_self
{
    my $app  = shift;
    my $self = $app->param('__CAP_DEVPOPUP_TIMER');
    $self ||= bless [], __PACKAGE__;
    $app->param( '__CAP_DEVPOPUP_TIMER' => $self );
    $self;
}

=head1 NAME

CGI::Application::Plugin::DevPopup::Timing - show timing information about cgiapp stages

=head1 SYNOPSIS

    use CGI::Application::Plugin::DevPopup;
    use CGI::Application::Plugin::DevPopup::Timing;

    The rest of your application follows
    ...

=head1 SEE ALSO

L<CGI::Application::Plugin::DevPopup>, L<CGI::Application>

=head1 AUTHOR

Rhesa Rozendaal, C<rhesa@cpan.org>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-cgi-application-plugin-devpopup@rt.cpan.org>, or through the web
interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CGI-Application-Plugin-DevPopup>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2005 Rhesa Rozendaal, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;    # End of CGI::Application::Plugin::DevPopup::Timing

