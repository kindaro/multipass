`multipass`
===========

_Remember only one password, but log in to each service with a unique one._

Warning:
--------

This program is in **experimental** stage of development. And, in any way, there are no guarantees
as to the cryptographic strength of the algorithms and the security of the program in general.

Idea in a nutshell:
-------------------

It is undesirable to have only a single password and use it for every service out there. You never
know if the provider actually hashes the secret string one entrusts them with _(Either out of
malice or carelessness)_. Yet, it is hard and dangerous to remember multiple passwords: human
memory is fragile and temporary.  One may find themselves locked out of an account the morning
after an intense party, or when the account is long since logged in the last time. Similarly, it
is hard and dangerous to maintain a password store: it is tied to a physical medium that has to be
carried around, backed up and cared for. In the case of loss, every secret stored is lost forever;
in the case of theft, the enemy will have to guess or extort the key, but then all the secrets are
in plain sight.

To avoid such misfortune, one way is to only remember one password but modify it in some
predictable fashion for each new account one creates, for example, by combining it with the name
of the service the account is made for. Yet, the malicious service provider may take a hard look
at the string they receive _(in the future references, the "password")_ and try to guess the way
it was crafted.  So, for example, concatenating the service name _(in the future, the "salt")_
with the single remembered password _(in the future, the "secret")_ will not take one far in terms
of safety of the secret: it will protect the secret if the _hash_ of the password is stolen, but
will be of no use if the password was stored in plain text, or if the provider themselves is
malicious.  For instance, if someone steals a plain text password for a Facebook account, from a
string like "`facebook_p4ssw0rd`" it is not hard to guess that the actual secret is "p4ssw0rd"
and, furthermore, that the corresponding mailbox may be opened with something like
"`mail_p4ssw0rd`".

So, it is desirable to have a method for securely combining the secret and the salt. `multipass`
offers one such method. Of course, once any provider manages to guess the salt, break the password
and obtain the secret, they may access any other account created with the same secret, for any
other service for which the salt can be guessed. _(Still somewhat better than having a password
store cracked, since the exact list of other accounts remains unknown to the attacker, --- but not
by much.)_ The good news is that brute force guessing the right secret for a given hash may take
years if the secret is somewhere about 16 usual ASCII characters.  In particular, it is faster to
crack, say, a million passwords of 8 randomly chosen latin characters, than one of 16, but the
latter is markedly easier to remember.
