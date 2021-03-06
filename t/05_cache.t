use Test::More;
use FindBin qw($Bin);
use File::Path;
use Perlanet::Simple;
chdir $Bin;

eval { require CHI; };

SKIP: {
  skip 'CHI required for caching test', 1 if $@;

  chdir($Bin);

  my $p = Perlanet::Simple->new_with_config(configfile => 'cacherc');

  rmtree($p->cache->root_dir);

  my $entries = $p->select_entries(
                  $p->fetch_feeds(
                    $p->feeds,
                  ),
                );
  my $first_count = scalar @$entries;

  $entries = $p->select_entries(
               $p->fetch_feeds(
                 $p->feeds,
               ),
             );

  my $second_count = scalar @$entries;

  # count should be the same on a second attempt
  is($first_count, $second_count, "$first_count == $second_count");

  rmtree($p->cache->root_dir);
}

done_testing();
