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

=type Kernel

A subtype for POE::Kernel.

=cut

subtype Kernel,
    as 'POE::Kernel';

=type Wheel

A subtype for POE::Wheel.

=cut

subtype Wheel,
    as 'POE::Wheel';

=type Filter

A subtype for POE::Filter.

=cut 

subtype Filter,
    as 'POE::Filter';

=type Driver

A subtype for POE::Driver.

=cut

subtype Driver,
    as 'POE::Driver';

=type Session

This sets an isa constraint on POE::Session

=cut

subtype Session,
    as 'POE::Session';

=type SessionID

Session IDs in POE are represented as positive integers and this Type 
constrains as such

=cut

subtype SessionID,
    as Int,
    where { $_ > 0 },
    message { 'Something is horribly wrong with the SessionID.' };

=type SessionAlias

Session aliases are strings in and this is simply an alias for Str

=cut

subtype SessionAlias,
    as Str;

=type DoesSessionInstantiation

This sets a constraint for an object that does
POEx::Role::SessionInstantiation

=cut

subtype DoesSessionInstantiation,
    as 'Moose::Object',
    where { $_->does('POEx::Role::SessionInstantiation') };

=type SessionRefIdAliasInstantiation

This is a convience type that checks for the above types in one go.

=cut

subtype SessionRefIdAliasInstantiation,
    as Session|SessionID|SessionAlias|DoesSessionInstantiation;

=type WheelID

WheelIDs are represented as positive integers

=cut

subtype WheelID,
    as Int,
    where { $_ > 0 },
    message { 'Something is horribly wrong with WheelID.' };


=coerce SessionID

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

=coerce SessionAlias

You can also coerce a SessionAlias from a SessionID, Session, or DoesSessionInstantiation
(via to_SessionAlias)

=cut

coerce SessionAlias,
    from SessionID,
        via { ($poe_kernel->alias_list($_))[0]; },
    from Session,
        via { ($poe_kernel->alias_list($_))[0]; },
    from DoesSessionInstantiation,
        via { $_->alias; };

=coerce Session

And finally a Session can be coerced from a SessionID, or SessionAlias (via to_Session)

=cut

coerce Session,
    from SessionID,
        via { $poe_kernel->ID_id_to_session($_) },
    from SessionAlias,
        via { $poe_kernel->alias_resolve($_) };

1;

__END__
