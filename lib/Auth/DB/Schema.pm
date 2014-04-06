package Auth::DB::Schema;
use utf8;
use strict;
use warnings;
use Teng::Schema::Declare;

table {
	name			'users';
	pk				'user_id';
	columns		qw(password last_login_at);
};

1;

