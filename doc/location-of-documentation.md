
(From a conversation on the [Ethersphere HQ Gitter channel](https://gitter.im/ethersphere/hq) on 2019-03-27)

me: Is there any automatic tooling that uploads https://github.com/ethersphere/swarm-home to swarm?

X: @adamschmideg no, @Y mentioned he would work on this in the near future

X: you have to first build a  `release` out of the github repo, and only then publish it to swarm

me: We could have done markdown files instead of html, and make conversion a part of the release.
I mean using a static site generator and release its output.

Z: assuming that the generator produces a correct and non-buggy output....

me: what do you mean?
I’d expect a ssg to produce correct output :)

X: why markdown files instead of html?
it is a basic static website, we don’t need any additional abstractions to maintain it
it works just fine as it is, let’s not introduce changes to something that works

Z:
> what do you mean?
correct positioning of elements across different resolutions, fine tuning the designs and making it all sit tight. i'm not a big fan of these tools
they are rather limited
and i agree with X we shouldn't introduce more complexity here
we dont update the site so often and not because its difficult to update
it would be nice to have the uploader tooling done though

X: the design of the website is great, the problem is that noone from us updates it with relevant content - this is not a problem of our tooling

me: I’m looking for the best central place for content, such as How to access the end-to-end test stats.
swarm-home looks the best bet to me.
Why markdown? Because it already has lots of boilerplate in html
