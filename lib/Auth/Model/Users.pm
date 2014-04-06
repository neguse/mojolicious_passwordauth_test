package Auth::Model::Users;
use utf8;
use strict;
use warnings;

use parent 'Auth::Model';

use Crypt::PBKDF2;

sub _init {
	my ($self, @args) = @_;
	$self->SUPER::_init(@args);

	my $db = @args;
	$self->{pbkdf2} = Crypt::PBKDF2->new;
	return $self;
}

sub insert {
	my $self = shift;
	my ($user_id, $raw_password) = @_;
	my $password_hashed = $self->{pbkdf2}->generate($raw_password);
	my $row = $self->{db}->insert(users => {
			user_id => $user_id,
			password => $password_hashed,
		});
	return $row;
}

sub validate {
	my $self = shift;
	my ($user_id, $raw_password) = @_;

	my $row = $self->{db}->single(users => {user_id => $user_id});
	if (!defined $row) {
		return 0;
	}
	my $res = $self->{pbkdf2}->validate($row->password, $raw_password);
	return $res;
}

sub login {
	my $self = shift;
	my ($user_id) = @_;

	my $row_count = $self->{db}->update('users',
		{
			last_login_at => time,
		},
		{
			user_id => $user_id,
		});

	return $row_count == 1;
}

sub single {
	my $self = shift;
	my ($user_id) = @_;
	my $row = $self->{db}->single(users => {user_id => $user_id});
	return $row;
}

1;


