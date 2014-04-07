#!/usr/bin/env perl
use utf8;
use strict;
use warnings;

use Test::More;
use Test::Mojo;

use FindBin;
require "$FindBin::Bin/../script/auth_lite";

my $t = Test::Mojo->new;
$t->ua->max_redirects(1);

$t->get_ok('/')
  ->status_is(200)
	->element_exists('a[href="/login"]');

# 未ログイン状態でrestrictedにアクセスするとログインにリダイレクトされる
$t->get_ok('/restricted/')
  ->status_is(200)
	->text_like('html body' => qr/ログインログイン/);

$t->get_ok('/login')
  ->status_is(200)
	->element_exists('form[method="post"]')
	->element_exists('input[name="user_id"]')
	->element_exists('input[name="password"]')
	->element_exists('button[type="submit"]');

# パスワードを間違えると再度ログイン画面
$t->post_ok('/login', form => {user_id => 'neguse', password => 'mogemoge'})
  ->status_is(200)
	->element_exists('form[method="post"]')
	->element_exists('input[name="user_id"]')
	->element_exists('input[name="password"]')
	->element_exists('button[type="submit"]')
	->element_exists('b', qr/間違って/);

# パスワードがあっているとrestrictedにリダイレクトされる
$t->post_ok('/login', form => {user_id => 'neguse', password => 'hogehoge'})
  ->status_is(200)
	->text_like('html body' => qr/neguseーサン。/);
# ログインした後はrestrictedに直接アクセスできる
$t->get_ok('/restricted/')
  ->status_is(200)
	->text_like('html body' => qr/neguseーサン。/);

done_testing();

