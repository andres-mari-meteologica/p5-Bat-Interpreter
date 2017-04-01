package Bat::Interpreter::Delegate::Executor::DryRunner;

use utf8;

use Moose;
use namespace::autoclean;

with 'Bat::Interpreter::Role::Executor';

# VERSION

=encoding utf-8

=head1 NAME

Bat::Interpreter::Delegate::Executor::DryRunner - Executor for register all commands that get executed

=head1 SYNOPSIS

    use Bat::Interpreter;
    use Bat::Interpreter::Delegate::Executor::DryRunner;

    my $dry_runner = Bat::Interpreter::Delegate::Executor::DryRunner->new;

    my $interpreter = Bat::Interpreter->new(executor => $dry_runner);
    $interpreter->run('my.cmd');
    
    print Dumper($dry_runner->commands_executed);
     
=head1 DESCRIPTION

This executor tries to get all the commands that are going to be executed, that is, it's like every
command gets "echoed" in the "standard output" as an array of lines

The commands printed can be different to the real execution if the bat/cmd file makes 
some sort of conditional using ERRORLEVEL 

=head1 METHODS

=cut

has 'commands_executed' => (
    is => 'ro',
    isa => 'ArrayRef',
    traits => ['Array'],
    default => sub { [] },
    handles => {
        add_command => 'push'
    }
);

has 'for_commands_executed' => (
    is => 'ro',
    isa => 'ArrayRef',
    traits => ['Array'],
    default => sub { [] },
    handles => {
        add_for_command => 'push'
    }
);


=head2 execute_command

Execute general commands.

This executor just register the command in the attribute: commands_executed

=cut

sub execute_command {
    my $self = shift();
    my $command = shift();
    $self->add_command($command);
    return 0;
}

=head2 execute_for_command

Execute commands for use in FOR expressions.
This is usually used to capture output and
implement some logic inside the bat/cmd file.

This executor can't return the output 
so it always returns empty string

=cut

sub execute_for_command {
    my $self = shift();
    my $command = shift();
    $self->add_for_command($command);
    return ''; # 
}

1;
