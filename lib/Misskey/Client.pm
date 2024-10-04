package Misskey::Client;

use v5.38;
use strict;
use warnings;
use feature 'class';
no warnings 'experimental::class';

=head1 NAME

Misskey::Client - The great new Misskey::Client!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Misskey::Client;

    my $foo = Misskey::Client->new(instance => 'https://example.local', token => 'x');
    ...

=cut

class Misskey::Client {
    use HTTP::Request();
    use LWP::UserAgent();
    use PerlX::Maybe;
    use JSON::MaybeXS qw(encode_json decode_json);
    use Misskey::Preconditions qw(verifyVisibility, verifyCW);

    # Params for constructor ->new()
    field $instance :param;
    field $token :param;
 
    field $userAgent = LWP::UserAgent->new();

    method setUserAgent($agent) {
        $userAgent->agent($agent);
    }

    method _handleResponse($response) {
        if ($response->code eq '200') {
            # decode_json wants bytes, so we ask decoded_content for
            # bytes; we don't call ->content because that may return
            # compressed data
            return decode_json($response->decoded_content(charset=>'none'));
        }
        else {
            die $response->as_string;
        }
    }

    method postRequest($endpoint, $content=undef, $headers={}) {
        return $self->_handleResponse($userAgent->request(
            HTTP::Request->new(
                POST => "$instance$endpoint",
                HTTP::Headers->new($headers->%*, 'Content-Type' => 'application/json'),
                (!$content ? '{}' : encode_json($content)),
            ),
        ));
    }

    method getRequest($endpoint, $headers={}) {
        return $self->_handleResponse($userAgent->request(
            HTTP::Request->new(
                GET => "$instance$endpoint",
                HTTP::Headers->new($headers->%*, 'Accept' => 'application/json'),
            ),
        ));
    }

    method postRequestAuth($endpoint, $content=undef) {
        return $self->postRequest($endpoint, $content, {
            Authorization => "Bearer $token",
        });
    }

    method getRequestAuth($endpoint) {
        return $self->getRequest($endpoint, {
            Authorization => "Bearer $token",
        });
    }

    method createNote($text, $visibility=undef, $cw=undef, $localOnly=undef) {
        Misskey::Preconditions::verifyVisibility($visibility);
        Misskey::Preconditions::verifyCW($cw);
        return $self->postRequestAuth('/api/notes/create', {
           maybe visibility => $visibility,
           maybe cw => $cw,
           maybe localOnly => $localOnly,
           text => $text
        });
    }

    # TOOD: return MisskeyMeta class
    method getMeta() {
        return $self->postRequest('/api/meta');
    }

    # TODO: return MisskeyAccount class
    method getSelf() {
        return $self->postRequestAuth('/api/i');
    }
}

=head1 AUTHOR

Amber Null, C<< <amber at transfem.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-misskey-client at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Misskey-Client>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Misskey::Client


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Misskey-Client>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Misskey-Client>

=item * Search CPAN

L<https://metacpan.org/release/Misskey-Client>

=back


=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2024 by Amber Null.

This is free software, licensed under:

  The MIT (X11) License

=cut

1; # End of Misskey::Client
