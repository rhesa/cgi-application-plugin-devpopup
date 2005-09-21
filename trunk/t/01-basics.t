use Test::More tests => 1;
use Data::Dumper;

{
	package My::App;
	use base qw/CGI::Application/;
	use CGI::Application::Plugin::DevPopup;

	sub setup
	{
		my $self = shift;
		$self->add_callback('devpopup_report', 'my_report');
		$self->start_mode('runmode');
		$self->run_modes([ qw/runmode/ ]);
	}

	sub runmode
	{
		my $self = shift;
		return '<html><body>Hi there!</body></html>';
	}

	sub my_report
	{
		my $self = shift;
		my $outputref = shift;
		$self->devpopup->add_report(
			title => 'Test 1',
			report => 'Test 1 report body',
		);
	}
}

$ENV{CGI_APP_RETURN_ONLY} = 1;

my $app    = My::App->new;
my $output = $app->run;

like($output, qr/Test 1 report body/, 'Report added');

# diag(Dumper($app->devpopup));
# diag($output);

__END__
1..1
ok 1 - Report added
# $VAR1 = bless( [
#                  {
#                    'report' => 'Test 1 report body',
#                    '__last__' => 0,
#                    '__counter__' => undef,
#                    '__first__' => 0,
#                    'title' => 'Test 1',
#                    '__odd__' => 0,
#                    '__inner__' => 0
#                  }
#                ], 'CGI::Application::Plugin::DevPopup' );
# Content-Type: text/html; charset=ISO-8859-1
# 
# <html><body>Hi there!
# 	<script language="javascript">
# 	var devpopup_window = window.open("", "devpopup_window", "height=400,width=600");
# 	devpopup_window.document.write("<?xml version=\"1.0\"?>\n" + 
# 	"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\"\n" + 
# 	"    \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n" + 
# 	"\n" + 
# 	"<html xmlns=\"http://www.w3.org/1999/xhtml\">\n" + 
# 	"<head>\n" + 
# 	"	<title>Devpopup results</title>\n" + 
# 	"	<style type=\"text/css\">\n" + 
# 	"		td			{ font-family: monospace; white-space: pre   }\n" + 
# 	"	</style>\n" + 
# 	"</head>\n" + 
# 	"<body>\n" + 
# 	"<h1>Devpopup report for My::App -&gt; runmode</h1>\n" + 
# 	"<div id=\"titles\">\n" + 
# 	"<ul>\n" + 
# 	"\n" + 
# 	"    <li><a href=\"#DP1\">Test 1</a></li>\n" + 
# 	"\n" + 
# 	"</ul>\n" + 
# 	"\n" + 
# 	"\n" + 
# 	"<div id=\"#DP1\" class=\"report\">\n" + 
# 	"	<div id=\"#DPS1\" class=\"report_summary\"></div>\n" + 
# 	"	<div id=\"#DPR1\" class=\"report_full\">Test 1 report body</div>\n" + 
# 	"</div>\n" + 
# 	"\n" + 
# 	"\n" + 
# 	"</body>\n" + 
# 	"</html>\n" + 
# 	"");
# 	devpopup_window.document.close();
# 	devpopup_window.focus();
# 	</script>
# 	
# </body></html>
