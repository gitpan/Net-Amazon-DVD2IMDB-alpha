package Net::Amazon::DVD2IMDB;

use LWP::Simple;
use Net::Amazon;
use Net::Amazon::Request::Keyword;

sub new {
  my $ref = shift;
  my $class = ref( $ref ) || $ref;

  my $self = bless {
    token => undef,
    amazon => undef,
    @_
  }, $class;

  die "Amazon Token Required" unless ( $self->{token} );

  $self->{amazon} = new Net::Amazon( token => $self->{token} );

  return $self;
}

sub convert {
  my ( $self, @titles ) = @_;
  return $self->asin2imdb( $self->dvd2asin( @titles ) );
}

sub dvd2asin {
  my ( $self, @titles ) = @_;

  @titles = map {
    my $asin = undef;
    my $r = Net::Amazon::Request::Keyword->new( keyword => $_, mode => 'dvd' );
    my $resp = $self->{amazon}->request( $r );

    if( $resp->is_success() ) { 
      foreach my $item ( $resp->properties ) {
        $asin ||= $item->Asin();
      }
    }

    $asin;
  } @titles;

  wantarray ? @titles : $titles[0];
}

sub asin2imdb {
  my ( $self, @asin ) = @_;

  @asin = map { 
    my @found;
    my $page = get( "http://www.amazon.com/exec/obidos/ASIN/$_" );

    while ( $page =~ /imdb.*?\?(\d+)/ig ) {
      push( @found, $1 );
    }

    [ @found ];
  } @asin;

  wantarray ? @asin : $asin[0];
}
1;
