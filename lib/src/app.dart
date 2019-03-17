import 'package:flutter/material.dart';
import 'package:paper_onboarding/src/reveal.dart';
import 'package:paper_onboarding/src/page.dart';

const data = [
  {
    'asset': 'lib/assets/hotels.png',
    'title': 'Hotels',
    'description': 'All hotels and hostels sorted by hospitality rating',
    'color': Color(0xff678FB4),
    'icon': 'lib/assets/key.png'
  },
  {
    'asset': 'lib/assets/banks.png',
    'title': 'Banks',
    'description': 'We carefully verify all banks before add them into the app',
    'color': Color(0xff65B0B4),
    'icon': 'lib/assets/wallet.png',
  },
  {
    'asset': 'lib/assets/stores.png',
    'title': 'Stores',
    'description': 'All local stores are categorized for your convenience',
    'color': Color(0xff9B90BC),
    'icon': 'lib/assets/shopping_cart.png',
  }
];

const INDICATOR_SIZE = 16.0;
const INDICATOR_MARGIN = 20.0;
const MAXIMUM_INDICATOR_SIZE = 40.0;
const DIFFERENCES = 40.0 - 16.0;

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {
  AnimationController _slideController, _revealController;
  PageController _pageController;

  Color backgroundColor;
  bool isForward = true;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    backgroundColor = data[0]['color'];

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _revealController.addListener(() {
      setState(() {});
    });

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
      lowerBound: 0.0,
      upperBound: 2.0,
    );

    _slideController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  Widget _fillCircle() {
    return Container(
      margin: const EdgeInsets.only(
        right: INDICATOR_MARGIN,
      ),
      width: INDICATOR_SIZE,
      height: INDICATOR_SIZE,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }

  Widget _emptyCircle() {
    return Container(
      margin: const EdgeInsets.only(
        right: INDICATOR_MARGIN,
      ),
      width: INDICATOR_SIZE,
      height: INDICATOR_SIZE,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          style: BorderStyle.solid,
          color: Colors.white,
        ),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildIndicators() {
    final width = MediaQuery.of(context).size.width;

    List<Widget> list = List();
    for (var i = 0; i < data.length; i++) {
      if (isForward && i < _slideController.value.floor()) {
        list.add(_fillCircle());
      }

      if (isForward && _slideController.value.ceil() == i) {
        final size = _slideController.value == 0.0
            ? MAXIMUM_INDICATOR_SIZE
            : INDICATOR_SIZE +
                ((_slideController.value -
                        (_slideController.value.ceil() - 1)) *
                    DIFFERENCES);
        list.add(Container(
          width: size,
          height: size,
          child: Image.asset(
            data[i]['icon'],
            fit: BoxFit.contain,
          ),
          margin: const EdgeInsets.only(
            right: INDICATOR_MARGIN,
          ),
        ));
      }

      if (isForward &&
          _slideController.value.floor() == i &&
          _slideController.value != i) {
        final size = _slideController.value == 0.0
            ? MAXIMUM_INDICATOR_SIZE
            : MAXIMUM_INDICATOR_SIZE -
                ((_slideController.value -
                        (_slideController.value.ceil() - 1)) *
                    DIFFERENCES);
        list.add(Container(
          width: size,
          height: size,
          child: Image.asset(
            data[i]['icon'],
            fit: BoxFit.contain,
          ),
          margin: const EdgeInsets.only(
            right: INDICATOR_MARGIN,
          ),
        ));
      }

      if (isForward &&
          _slideController.value.ceil() < i + 1 &&
          i < data.length - 1) {
        list.add(_emptyCircle());
      }

      if (!isForward && _slideController.value.ceil() < i) {
        list.add(_emptyCircle());
      }

      if (!isForward &&
          _slideController.value.ceil() == i &&
          _slideController.value.floor() != i) {
        final size = _slideController.value == 0.0
            ? MAXIMUM_INDICATOR_SIZE
            : INDICATOR_SIZE +
                ((_slideController.value - _slideController.value.floor()) *
                    DIFFERENCES);
        list.add(Container(
          width: size,
          height: size,
          child: Image.asset(
            data[i]['icon'],
            fit: BoxFit.contain,
          ),
          margin: const EdgeInsets.only(
            right: INDICATOR_MARGIN,
          ),
        ));
      }

      if (!isForward && _slideController.value.floor() == i) {
        final size = _slideController.value == 0.0
            ? MAXIMUM_INDICATOR_SIZE
            : MAXIMUM_INDICATOR_SIZE -
                ((_slideController.value - _slideController.value.floor()) *
                    DIFFERENCES);
        list.add(Container(
          width: size,
          height: size,
          child: Image.asset(
            data[i]['icon'],
            fit: BoxFit.contain,
          ),
          margin: const EdgeInsets.only(
            right: INDICATOR_MARGIN,
          ),
        ));
      }

      if (!isForward && _slideController.value.floor() > i) {
        list.add(_fillCircle());
      }
    }

    return Container(
      padding: EdgeInsets.only(
        left: (width / 2) -
            INDICATOR_MARGIN -
            (_slideController.value * (INDICATOR_MARGIN + INDICATOR_SIZE)),
      ),
      child: Row(
        children: list,
      ),
    );
  }

  _buildBackground() {
    if (_revealController.isCompleted) {
      return SizedBox(
        height: 0,
        width: 0,
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomPaint(
        painter: RevealProgressButtonPainter(
            _revealController.value,
            MediaQuery.of(context).size,
            isForward
                ? data[_slideController.value.ceil()]['color']
                : data[_slideController.value.floor()]['color']),
      ),
    );
  }

  _buildPage() {
    if (!_revealController.isAnimating) {
      return Container(
        margin: EdgeInsets.only(
          top: 0,
        ),
        child: Page(
          assetPath: data[isForward
              ? _slideController.value.ceil()
              : _slideController.value.floor()]['asset'],
          title: data[isForward
              ? _slideController.value.ceil()
              : _slideController.value.floor()]['title'],
          description: data[isForward
              ? _slideController.value.ceil()
              : _slideController.value.floor()]['description'],
          background: data[isForward
              ? _slideController.value.ceil()
              : _slideController.value.floor()]['color'],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(
        top: INDICATOR_MARGIN - INDICATOR_MARGIN * _revealController.value,
      ),
      child: Page(
        assetPath: data[isForward
            ? _slideController.value.ceil()
            : _slideController.value.floor()]['asset'],
        title: data[isForward
            ? _slideController.value.ceil()
            : _slideController.value.floor()]['title'],
        description: data[isForward
            ? _slideController.value.ceil()
            : _slideController.value.floor()]['description'],
        background: data[isForward
            ? _slideController.value.ceil()
            : _slideController.value.floor()]['color'],
      ),
    );
  }

  void onPageChange(int page) {
    if (page > _slideController.value) {
      isForward = true;
    }

    if (page < _slideController.value) {
      isForward = false;
    }

    _revealController
        .animateTo(
      1.0,
      curve: Curves.easeOut,
    )
        .then((_) {
      _revealController.reset();
    });

    _slideController
        .animateTo(
      page.toDouble(),
      curve: Curves.easeOut,
    )
        .then((_) {
      setState(() {
        backgroundColor = data[page]['color'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          _buildBackground(),
          _buildPage(),
          PageView.builder(
            onPageChanged: onPageChange,
            controller: _pageController,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int position) {
              return Container();
            },
            physics: BouncingScrollPhysics(),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            height: 40,
            width: width,
            child: _buildIndicators(),
          )
        ],
      ),
    );
  }
}
