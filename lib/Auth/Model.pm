package Auth::Model;
use utf8;
use strict;
use warnings;

sub new {
	my ($class, @args) = @_;
	my $self = bless {}, $class;
	return $self->_init(@args);
}

sub _init {
	my ($self, $db) = @_;
	$self->{db} = $db;
	return $self;
}

1;

