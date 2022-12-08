package Tree;

sub new {
    my $class = shift;
    my $self = {
        _visible => 0,
        _height => shift,
        _rowno => shift,
        _colno => shift,
        _scenic_score => 0,
    };
    bless $self, $class;
    return $self;
}

sub get_visible {
    my ( $self ) = @_;
    return $self->{_visible};
}

sub get_height {
    my ( $self ) = @_;
    return $self->{_height};
}

sub get_row {
    my ( $self ) = @_;
    return $self->{_rowno};
}

sub get_col {
    my ( $self ) = @_;
    return $self->{_colno};
}

sub get_scenic_score {
    my ( $self ) = @_;
    return $self->{_scenic_score};
}

sub set_scenic_score {
    my ( $self, $value ) = @_;
    $self->{_scenic_score} = $value;
    return;
}

sub set_visibility {
    my ( $self, $value ) = @_;
    $self->{_visible} = $value;
    return;
}

sub update_trees {
    my ( @treelist ) = @_;
    
    my $list_length = scalar(@treelist);
    my $edge_length = sqrt($list_length);

    foreach $tree (@treelist) {
        my @tree_list_to_edges = ();
        my $found_visibility = 0;

        # Set all trees on perimeter to visible
        if (($tree->get_row() == 0) or 
            ($tree->get_col() == 0) or 
            ($tree->get_row() == $edge_length - 1) or 
            ($tree->get_col() == $edge_length - 1) 
        ) {
            $tree->set_visibility(1);
            $found_visibility => 1;
        }
        
        my $visibility_left = 1;
        my $visibility_right = 1;
        my $visibility_up = 1;
        my $visibility_down = 1;

        my $tree_visible_left = 0;
        my$tree_visible_right = 0;
        my $tree_visible_up = 0;
        my $tree_visible_down = 0;

        # Check to the left
        for ($i = $tree->get_col() - 1; $i >= 0; $i--) {
            $tree_visible_left++;
            
            if ($tree->get_height() <= @treelist[($tree->get_row() * $edge_length) + $i]->get_height()) {
                $visibility_left = 0;
                last;
            }
        }
        
        # Check to the right
        for ($i = $tree->get_col() + 1; $i < $edge_length; $i++) {
            $tree_visible_right++;

            if ($tree->get_height() <= @treelist[($tree->get_row() * $edge_length) + $i]->get_height()) {
                $visibility_right = 0;
                last;
            }
        }

        # Check above
        for ($i = $tree->get_row() - 1; $i >= 0; $i--) {
            $tree_visible_up++;

            if ($tree->get_height() <= @treelist[($i * $edge_length) + $tree->get_col()]->get_height()) {
                $visibility_up = 0;
                last;
            }
        }

        # Check below
        for ($i = $tree->get_row() + 1; $i < $edge_length; $i++) {
            $tree_visible_down++;

            if ($tree->get_height() <= @treelist[($i * $edge_length) + $tree->get_col()]->get_height()) {
                $visibility_down = 0;
                last;
            }
        }

        $tree->set_scenic_score($tree_visible_left * $tree_visible_right * $tree_visible_up * $tree_visible_down);

        if ($found_visibility == 0) {
            if ($visibility_left == 1 or 
                $visibility_right == 1 or 
                $visibility_up == 1 or 
                $visibility_down == 1
            ) {
                $tree->set_visibility(1);
            } else {
                $tree->set_visibility(0);
            }
        }
    }
}

sub get_number_visible_trees {
    my ( @tree_list ) = @_;
    $number_visible = 0;
    foreach $tree (@tree_list) {
        if ($tree->get_visible() == 1) {
            $number_visible++;
        }
    }
    return $number_visible;
}

sub pretty_print {
    my ( $self ) = @_;
    print "Tree[$self->{_rowno},$self->{_colno}] - Visible: $self->{_visible}, Height: $self->{_height}\n";
    return;
}

sub display_tree_map {
    my ( $display_type, @treelist ) = @_;

    $current_row = 0;
    foreach $tree (@treelist) {
        if ($tree->get_row() != $current_row) {
            $current_row = $tree->get_row();
            print "\n";
        }
        
        if ($display_type eq "height") {
            print $tree->get_height(), " ";
        } elsif ($display_type eq "visibility") {
            print $tree->get_visible(), " ";
        } elsif ($display_type eq "scenic score") {
            print $tree->get_scenic_score(), " ";
        } elsif ($display_type eq "pretty print") {
            $tree->pretty_print();
        }
    }
    print "\n";
}

sub get_highest_scenic_score {
    my ( @treelist ) = @_;
    $highest_scenic_score = 0;
    foreach $tree (@treelist) {
        if ($tree->get_scenic_score() > $highest_scenic_score) {
            $highest_scenic_score = $tree->get_scenic_score();
        }
    }
    return $highest_scenic_score;
}

1;