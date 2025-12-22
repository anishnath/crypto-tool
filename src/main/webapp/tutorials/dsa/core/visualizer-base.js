/**
 * Base Visualizer Class
 * Foundation for all DSA visualizations
 */
class DSAVisualizer {
    constructor(containerId, config = {}) {
        this.containerId = containerId;
        this.container = document.getElementById(containerId);
        this.isRunning = false;
        this.isPaused = false;
        this.speed = config.speed || 800;
        this.stats = {};

        // Default configuration
        this.config = {
            showIndices: config.showIndices !== false,
            showStats: config.showStats !== false,
            showOperation: config.showOperation !== false,
            animationEasing: config.animationEasing || 'cubic-bezier(0.68, -0.55, 0.265, 1.55)',
            colors: {
                default: 'linear-gradient(135deg, #60a5fa 0%, #3b82f6 100%)',
                comparing: 'linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%)',
                swapping: 'linear-gradient(135deg, #f97316 0%, #ea580c 100%)',
                sorted: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                current: 'linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%)',
                visited: 'linear-gradient(135deg, #6366f1 0%, #4f46e5 100%)',
                path: 'linear-gradient(135deg, #ec4899 0%, #db2777 100%)',
                error: 'linear-gradient(135deg, #ef4444 0%, #dc2626 100%)'
            },
            ...config
        };

        this.initializeStats();
    }

    initializeStats() {
        this.stats = {
            comparisons: 0,
            swaps: 0,
            accesses: 0,
            operations: 0
        };
    }

    updateStat(statName, value) {
        if (this.stats.hasOwnProperty(statName)) {
            this.stats[statName] = value;
            const element = document.getElementById(statName);
            if (element) {
                element.textContent = value;
            }
        }
    }

    incrementStat(statName, amount = 1) {
        if (this.stats.hasOwnProperty(statName)) {
            this.stats[statName] += amount;
            this.updateStat(statName, this.stats[statName]);
        }
    }

    updateOperation(text) {
        const opElement = document.getElementById('currentOp');
        if (opElement) {
            opElement.textContent = text;
        }
    }

    async sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    setSpeed(speed) {
        this.speed = speed;
    }

    start() {
        this.isRunning = true;
        this.isPaused = false;
    }

    pause() {
        this.isPaused = !this.isPaused;
    }

    stop() {
        this.isRunning = false;
        this.isPaused = false;
    }

    reset() {
        this.stop();
        this.initializeStats();
        Object.keys(this.stats).forEach(key => this.updateStat(key, 0));
    }

    // Utility methods
    getOrdinalSuffix(num) {
        const j = num % 10;
        const k = num % 100;
        if (j === 1 && k !== 11) return 'st';
        if (j === 2 && k !== 12) return 'nd';
        if (j === 3 && k !== 13) return 'rd';
        return 'th';
    }

    shuffleArray(array) {
        for (let i = array.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [array[i], array[j]] = [array[j], array[i]];
        }
        return array;
    }

    generateRandomArray(size, min = 1, max = 99) {
        return Array.from({ length: size }, () =>
            Math.floor(Math.random() * (max - min + 1)) + min
        );
    }
}

/**
 * Array Visualizer - For sorting and array-based algorithms
 */
class ArrayVisualizer extends DSAVisualizer {
    constructor(containerId, config = {}) {
        super(containerId, config);
        this.array = [];
        this.elements = [];
        this.arrayContainer = null;
    }

    render() {
        if (!this.arrayContainer) {
            this.arrayContainer = document.createElement('div');
            this.arrayContainer.className = 'array-container';
            this.container.appendChild(this.arrayContainer);
        }

        this.arrayContainer.innerHTML = '';
        this.elements = [];

        this.array.forEach((value, index) => {
            const box = this.createArrayBox(value, index);
            this.arrayContainer.appendChild(box);
            this.elements.push(box);
        });
    }

    createArrayBox(value, index) {
        const box = document.createElement('div');
        box.className = 'array-box';
        box.textContent = value;
        box.style.background = this.config.colors.default;

        if (this.config.showIndices) {
            box.setAttribute('data-index', `[${index}]`);
        }

        return box;
    }

    async highlightElements(indices, className, duration = null) {
        indices.forEach(i => {
            if (this.elements[i]) {
                this.elements[i].classList.add(className);
            }
        });

        if (duration) {
            await this.sleep(duration);
            indices.forEach(i => {
                if (this.elements[i]) {
                    this.elements[i].classList.remove(className);
                }
            });
        }
    }

    async compare(i, j) {
        await this.highlightElements([i, j], 'comparing', this.speed * 0.5);
        this.incrementStat('comparisons');
        this.incrementStat('accesses', 2);
        return this.array[i] > this.array[j];
    }

    async swap(i, j) {
        const box1 = this.elements[i];
        const box2 = this.elements[j];

        this.updateOperation(`Swapping ${this.array[i]} and ${this.array[j]}`);

        box1.classList.add('swapping');
        box2.classList.add('swapping');

        const rect1 = box1.getBoundingClientRect();
        const rect2 = box2.getBoundingClientRect();
        const distance = rect2.left - rect1.left;

        box1.style.transition = `transform ${this.speed * 0.6}ms ${this.config.animationEasing}`;
        box2.style.transition = `transform ${this.speed * 0.6}ms ${this.config.animationEasing}`;

        box1.style.transform = `translateX(${distance}px) translateY(-30px)`;
        box2.style.transform = `translateX(${-distance}px) translateY(-30px)`;

        await this.sleep(this.speed * 0.6);

        box1.style.transform = `translateX(${distance}px)`;
        box2.style.transform = `translateX(${-distance}px)`;

        await this.sleep(this.speed * 0.4);

        // Update DOM order
        if (i < j) {
            box2.parentNode.insertBefore(box2, box1);
        } else {
            box1.parentNode.insertBefore(box1, box2);
        }

        box1.style.transition = 'none';
        box2.style.transition = 'none';
        box1.style.transform = '';
        box2.style.transform = '';

        [this.array[i], this.array[j]] = [this.array[j], this.array[i]];
        [this.elements[i], this.elements[j]] = [this.elements[j], this.elements[i]];

        this.elements.forEach((box, idx) => {
            if (this.config.showIndices) {
                box.setAttribute('data-index', `[${idx}]`);
            }
        });

        this.incrementStat('swaps');
        this.incrementStat('accesses', 4);

        box1.classList.remove('swapping');
        box2.classList.remove('swapping');
    }

    async markSorted(index) {
        if (this.elements[index]) {
            this.elements[index].classList.add('sorted');
            await this.sleep(this.speed * 0.3);
        }
    }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { DSAVisualizer, ArrayVisualizer };
}
