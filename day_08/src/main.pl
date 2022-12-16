use File::Basename;
use lib dirname (__FILE__);
use Tree;

open(my $in, "<", "./data/input.dat") or die "Error reading file: $!";

my @tree_list;

$rowno = 0;
foreach $line (<$in>) {
    my @chars = split("", $line);

    for ($i = 0; $i < scalar(@chars) - 1; $i++) {
        my $tree = Tree->new(int($chars[$i]), $rowno, $i);
        push(@tree_list, $tree);
    }
    $rowno++;
}

close($in);

# Tree::display_tree_map("pretty print", @tree_list);

Tree::update_trees(@tree_list);

# print "Visibility Map:\n";
# Tree::display_tree_map("visibility", @tree_list);
print "Number of visible trees: ", Tree::get_number_visible_trees(@tree_list), "\n";
# print "\n";
# print "Scenic Score Map:\n";
# Tree::display_tree_map("scenic score", @tree_list);
print "Highest scenic score: ", Tree::get_highest_scenic_score(@tree_list);