package POEx::Types;
use warnings;
use strict;

#ABSTRACT: Exported Types for use within POEx modules

=head1 DESCRIPTION

This modules exports the needed subtypes, and coercions for POEx modules
and is based on Sub::Exporter, so see that module for options on importing.

=cut

use POE;
use MooseX::Types -declare => 
[ 
    'Driver', 
    'Filter', 
    'Wheel', 
    'WheelID', 
    'Kernel', 
    'SessionID', 
    'SessionAlias', 
    'Session', 
    'DoesSessionInstantiation',
    'SessionRefIdAliasInstantiation'
];
use MooseX::Types::Moose('Int', 'Str');
use MooseX::Types::Structured('Dict');

class_type 'POE::Kernel';
class_type 'POE::Session';
class_type 'POE::Wheel';
class_type 'POE::Filter';
class_type 'POE::Driver';

=head1 TYPES

=head2 Kernel

A subtype for POE::Kernel.

=cut

subtype Kernel,
    as 'POE::Kernel';

=head2 Wheel

A subtype for POE::Wheel.

=cut

subtype Wheel,
    as 'POE::Wheel';

=head2 Filter

A subtype for POE::Filter.

=cut 

subtype Filter,
    as 'POE::Filter';

=head2 Driver

A subtype for POE::Driver.

=cut

subtype Driver,
    as 'POE::Driver';

=head2 Session

This sets an isa constraint on POE::Session

=cut

subtype Session,
    as 'POE::Session';

=head2 SessionID

Session IDs in POE are represented as positive integers and this Type 
constrains as such

=cut

subtype SessionID,
    as Int,
    where { $_ > 0 },
    message { 'Something is horribly wrong with the SessionID.' };

=head2 SessionAlias

Session aliases are strings in and this is simply an alias for Str

=cut

subtype SessionAlias,
    as Str;

=head2 DoesSessionInstantiation

This sets a constraint for an object that does
POEx::Role::SessionInstantiation

=cut

subtype DoesSessionInstantiation,
    as 'Moose::Object',
    where { $_->does('POEx::Role::SessionInstantiation') };

=head2 SessionRefIdAliasInstantiation

This is a convience type that checks for the above types in one go.

=cut

subtype SessionRefIdAliasInstantiation,
    as Session|SessionID|SessionAlias|DoesSessionInstantiation;

=head2 WheelID

WheelIDs are represented as positive integers

=cut

subtype WheelID,
    as Int,
    where { $_ > 0 },
    message { 'Something is horribly wrong with WheelID.' };

=head1 COERCIONS

Most of these coercions require an active POE::Kernel and so their use is only
recommened inside a proper POE context

=head2 SessionID

You can coerce SessionAlias, Session, and DoesSessionInstantiation to a 
SessionID (via to_SessionID)

=cut

coerce SessionID,
    from SessionAlias,
        via { $poe_kernel->alias_resolve($_)->ID },
    from Session,
        via { $_->ID },
    from DoesSessionInstantiation,
        via { $_->ID };

=head2 SessionAlias

You can coerce Session, SessionID, and DoesSessionInstantiation to a 
SessionAlias (via to_SessionAlias)

=cut

coerce SessionAlias,
    from SessionID,
        via { ($poe_kernel->alias_list($_))[0]; },
    from Session,
        via { ($poe_kernel->alias_list($_))[0]; },
    from DoesSessionInstantiation,
        via { $_->alias; };

=head2 Session

You can coerce SessionAlias and SessionID to a SessionID (via to_Session)

=cut

coerce Session,
    from SessionID,
        via { $poe_kernel->ID_id_to_session($_) },
    from SessionAlias,
        via { $poe_kernel->alias_resolve($_) };

1;

__END__
