import { Optimizer } from '@parcel/plugin';

export default new Optimizer({
  async optimize({ contents, map }) {
    // let {code, sourceMap} = optimize(contents, map);

    let content = contents.toString();
    const html = contents.toString()
      .replace(
        '<meta name=yandex-verification content=5bbb42b19c3700ce>',
        '<head><meta name="yandex-verification" content="5bbb42b19c3700ce" /></head>'
      );
    // console.log('optimizer', html);

    return {
      contents: html,
      map: map
    };
  }
});