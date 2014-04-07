#!/usr/bin/env perl

use Test::More;
use Test::Exception;

use Auth::DB;
use Auth::Model::Users;

my $db = Auth::DB->new(+{
		connect_info => ['dbi:SQLite:', '', '']
	});

# TODO: DBの定義を別ファイルに逃がす
$db->do(q{
	CREATE TABLE IF NOT EXISTS users (
		user_id VARCHAR NOT NULL PRIMARY KEY,
		password VARCHAR NOT NULL,
		last_login_at DATETIME
	)
});

my $users = Auth::Model::Users->new($db);

# insert
my $pw_hashed;
{
	my $u = $users->insert('neguse', 'hogehoge');
	is($u->user_id, 'neguse');
	$pw_hashed = $u->password;

	throws_ok {
		my $u2 = $users->insert('neguse', 'mogemoge')
	} qr/.*UNIQUE/;
}

# validate
{
	ok($users->validate('neguse', 'hogehoge'));
	ok(!$users->validate('neguse', 'mogemoge'));
	ok(!$users->validate('nuguze', 'hogehoge'));
}

# login
{
	ok($users->login('neguse'));
	ok(!$users->login('nuguze'));
}

# single
{
	my $u = $users->single('neguse');
	is($u->user_id, 'neguse');
	is($u->password, $pw_hashed);
	cmp_ok($u->last_login_at, '<=', time);
}

done_testing();

